struct AppPresenter {
    let moduleNames: [String]
    
    var startModuleName: String {
        guard let name = moduleNames.first else {
            fatalError("moduleNames should not be empty")
        }
        return name
    }
}

extension AppPresenter: CustomStringConvertible {
    public var description: String {
        return """
        import Beaver
        
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
                presenter.dispatch(AppAction.start(withFirstAction: \(startModuleName)Action.start), recipients: .emitter)
        
                return (window, presenter)
            }
        }
        
        #endif
        
        extension AppPresenter {
            func stateDidUpdate(oldState: AppState?,
                                newState: AppState,
                                completion: @escaping () -> ()) {
        \(stateDidUpdateBody.indented(count: 2))
        
                completion()
            }
        }

        """
    }
    
    private var stateDidUpdateBody: String {
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
}

struct ModulePresenter {
    let moduleName: String
}

extension ModulePresenter: CustomStringConvertible {
    public var description: String {
        return """
        import Beaver
        
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
        
                // Present the stages or emit to the parent router here
        
                completion()
            }
        }
        
        """
    }
}
