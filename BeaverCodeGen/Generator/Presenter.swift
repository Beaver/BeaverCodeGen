struct AppPresenter: SwiftGenerating {
    let objectType: ObjectType = .presenter
    let name = "App"
    var moduleNames: [String]
    
    init(moduleNames: [String] = []) {
        self.moduleNames = moduleNames
    }
    
    var startModuleName: String {
        guard let name = moduleNames.first else {
            fatalError("moduleNames should not be empty")
        }
        return name
    }
}

extension AppPresenter {
    var description: String {
        return """
        import Beaver
        import Core
        \(moduleNames.map {
            "import \($0.typeName)"
        }.joined(separator: .br))
        
        #if os(iOS)
        import UIKit
        #endif
        
        final class ModulesContainer {
        \(moduleNames.map {
            "var \($0.varName): \($0.typeName)Presenter?"
        }.joined(separator: .br).indented)
        }
        
        final class AppPresenter: Presenting, Storing {
            typealias StateType = AppState
        
            let store: Store<AppState>
        
            let context: Context
        
            fileprivate let modules = ModulesContainer()
        
            init(context: Context,
                 store: Store<AppState>) {
                self.store = store
                self.context = context
            }
        }
        
        #if os(iOS)
        
        extension AppPresenter {
            static func bootstrap(state: AppState = AppState(),
                                  middlewares: [Store<AppState>.Middleware] = [.logging]) -> (UIWindow, AppPresenter) {
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.makeKeyAndVisible()
        
                let context = NavigationContext(parent: WindowContext(window: window))
        
                let reducer = AppReducer(
        \(moduleNames.map {
            "\($0.varName): \($0.typeName)Reducer()"
        }.joined(separator: ",".br).indented(count: 3))
                ).reducer
                let store = Store<AppState>(initialState: state, middlewares: middlewares, reducer: reducer)
                let presenter = AppPresenter(context: context, store: store)
        
                presenter.subscribe()
                presenter.dispatch(AppAction.start(module: \(startModuleName)RoutingAction.start), recipients: .emitter)
        
                return (window, presenter)
            }
        }
        
        #endif
        
        extension AppPresenter {
            func stateDidUpdate(oldState: AppState?,
                                newState: AppState,
                                completion: @escaping () -> ()) {
        \(stateDidUpdateBody(moduleNames).indented(count: 2))
        
                completion()
            }
        }

        """
    }
    
    private func stateDidUpdateBody(_ moduleNames: [String]) -> String {
        return moduleNames.map {
            """
            switch (oldState?.\($0.varName)State, newState.\($0.varName)State) {
            case (.none, .some):
                let childStore = ChildStore(store: store) { $0.\($0.varName)State }
                modules.\($0.varName) = \($0.typeName)Presenter(store: childStore, context: context)
                modules.\($0.varName)?.subscribe()
            
            case (.some, .none):
                modules.\($0.varName)?.unsubscribe()
                modules.\($0.varName) = nil
            
            default: break
            }
            """
        }.joined(separator: "".br(2))
    }
    
    func byInserting(module moduleName: String, in fileHandler: FileHandling) -> AppPresenter {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)
        
        guard let modulesContainer = swiftFile.find(isMatching: {
            $0.typeName == .modulesContainer && $0.kind == .`class`
        }).first as? SwiftIndexable & SwiftScanable else {
            fatalError("Couldn't find ModulesContainer in \(fileHandler)")
        }
        
        let moduleVars = modulesContainer.find {
            ($0.typeName?.isModulePresenter ?? false) && $0.kind == .`var`
        }
        let moduleVarOffset = moduleVars.last?.offset ?? modulesContainer.offset

        // Insert module import
        let selectorString = "import \(moduleVars.last?.typeName?.name.replacingOccurrences(of: "Presenter", with: "") ?? "Core")".br
        var insertedCharacterCount = fileHandler.insert(content: "import \(moduleName.typeName)".br,
                                                        atOffset: 0,
                                                        withSelector: .matching(string: selectorString, insert: .after),
                                                        inFileAtPath: path)

        // Insert module var
        insertedCharacterCount += fileHandler.insert(content: "var \(moduleName.varName): \(moduleName.typeName)Presenter?".indented.br,
                                                     atOffset: moduleVarOffset + insertedCharacterCount,
                                                     withSelector: .matching(string: .br, insert: .after),
                                                     inFileAtPath: path)
        
        guard let appReducerCall = swiftFile.find(recursive: true, isMatching: {
            $0.kind == .`call` &&
                $0.typeName == .appReducer &&
                $0.parent?.typeName == .appPresenterBootstrapMethod &&
                $0.parent?.kind == .staticMethod
        }).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find AppReducer call in \(fileHandler)")
        }
        
        let appReducerArgs = appReducerCall.find(recursive: true) {
            $0.kind == .`call` &&
                ($0.typeName?.isModuleReducer ?? false) &&
                $0.parent?.kind == .argument
        }
        let appReducerArgOffset = (appReducerArgs.last?.endOffset ?? appReducerCall.offset) + insertedCharacterCount
        
        // Insert module reducer
        insertedCharacterCount += fileHandler.insert(content: "," + .br + "\(moduleName.varName): \(moduleName.typeName)Reducer()".indented(count: 3).br,
                                                     atOffset: appReducerArgOffset,
                                                     withSelector: .matching(string: .br, insert: .over),
                                                     inFileAtPath: path)
        
        guard let stateDidUpdateMethod = swiftFile.find(recursive: true, isMatching: {
            $0.typeName == .presentingStateDidUpdateMethod &&
                $0.kind == .method &&
                $0.parent?.typeName == .appPresenter
        }).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find stateDidUpdate(oldState:newState:completion:) method in \(fileHandler)")
        }

        guard let stateDidUpdateSwitchOffset = stateDidUpdateMethod.endOffset else {
            fatalError("Couldn't compute offset to insert code in \(fileHandler)")
        }
        
        // Insert module switch case
        _ = fileHandler.insert(content: stateDidUpdateBody([moduleName]).indented(count: 2).br(2),
                               atOffset: stateDidUpdateSwitchOffset,
                               withSelector: .matching(string: "completion()".indented(count: 2), insert: .before),
                               inFileAtPath: path)
        
        return AppPresenter(moduleNames: moduleNames + [moduleName])
    }
}

struct ModulePresenter: SwiftGenerating {
    let objectType: ObjectType = .presenter
    let moduleName: String
}

extension ModulePresenter {
    var name: String {
        return moduleName
    }
    
    var description: String {
        return """
        import Beaver
        import Core
        
        public final class \(moduleName.typeName)Presenter: Beaver.Presenting, Beaver.ChildStoring {
            public typealias StateType = \(moduleName.typeName)State
            public typealias ParentStateType = AppState
        
            public let store: ChildStore<\(moduleName.typeName)State, AppState>
        
            public let context: Context
        
            public init(store: ChildStore<\(moduleName.typeName)State, AppState>,
                        context: Context) {
                self.store = store
                self.context = context
            }
        }
        
        extension \(moduleName.typeName)Presenter {
            public func stateDidUpdate(oldState: \(moduleName.typeName)State?,
                                       newState: \(moduleName.typeName)State,
                                       completion: @escaping () -> ()) {
        
                switch (oldState?.currentScreen ?? .none, newState.currentScreen) {
                case (.none, .main):
                    #if os(iOS)
                    let \(moduleName.varName)Controller = \(moduleName.typeName)ViewController(store: store)
                    context.present(controller: \(moduleName.varName)Controller, completion: completion)
                    #endif
        
                case (.main, .none):
                    #if os(iOS)
                    context.dismiss(completion: completion)
                    #endif
        
                default:
                    completion()
                }
            }
        }
        
        """
    }
}
