struct ModuleReducer: SwiftGenerating {
    let objectType: ObjectType = .reducer
    let moduleName: String
}

extension ModuleReducer {
    var name: String {
        return moduleName
    }
    
    var description: String {
        return """
        import Beaver
        import Core
        
        public struct \(moduleName.typeName)Reducer: Beaver.ChildReducing {
            public typealias ActionType = \(moduleName.typeName)Action
            public typealias StateType = \(moduleName.typeName)State
        
            public init() {
            }
        
            public func handle(action: \(moduleName.typeName)Action,
                               state: \(moduleName.typeName)State,
                               completion: @escaping (\(moduleName.typeName)State) -> ()) -> \(moduleName.typeName)State {
                var newState = state
        
                switch ExhaustiveAction<\(moduleName.typeName)RoutingAction, \(moduleName.typeName)UIAction>(action) {
                case .routing(.start):
                    newState.currentScreen = .main
        
                case .routing(.stop):
                    newState.currentScreen = .none
        
                case .ui:
                    break
                }
        
                return newState
            }
        }
        
        """
    }
}


struct AppReducer: SwiftGenerating {
    let objectType: ObjectType = .reducer
    var moduleNames: [String]
}

extension AppReducer {
    var name: String {
        return "App"
    }
    
    var description: String {
        return """
        import Beaver
        import Core
        \(moduleNames.map {
        "import \($0.typeName)"
        }.joined(separator: .br))
        
        struct AppReducer: Beaver.Reducing {
        \(moduleNames.count > 0 ? moduleNames.map {
            "let \($0.varName): \($0.typeName)Reducer"
        }.joined(separator: .br).indented.br : "")
            typealias StateType = AppState
        
            func handle(envelop: ActionEnvelop,
                        state: AppState,
                        completion: @escaping (AppState) -> ()) -> AppState {
                var newState = state
        
                // Reduce start action
        
                if case AppAction.start(let startAction) = envelop.action {
                    return handle(envelop: envelop.update(action: startAction), state: newState, completion: completion)
                }
        \(moduleNames.count > 0 ? .br + moduleActionCase(moduleNames).indented(count: 2).br : "")
                return newState
            }
        }
        
        """
    }
    
    private func moduleActionCase(_ moduleNames: [String]) -> String {
        return moduleNames.map {
            """
            // Reduce \($0.typeName)'s actions
            
            if envelop.action is \($0.typeName)Action {
                newState.\($0.varName)State = \($0.varName).handle(envelop: envelop, state: state.\($0.varName)State ?? \($0.typeName)State()) { \($0.varName)State in
                    newState.\($0.varName)State = \($0.varName)State
                    completion(newState)
                }
            }
            
            if case AppAction.stop(module: \($0.typeName)RoutingAction.stop) = envelop.action {
                newState.\($0.varName)State = nil
            }
            """
        }.joined(separator: .br(2))
    }
    
    func byInserting(module moduleName: String, in fileHandler: FileHandling) -> AppReducer {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)

        guard let reducerStruct = swiftFile.find(recursive: true, isMatching: {
            $0.typeName == .appReducer && $0.kind == .`struct` && $0.doesInherit(from: [.beaverReducing])
        }).first as? SwiftSubstructure else {
            fatalError("Couldn't find AppReducer in \(fileHandler)")
        }
        
        let reducerVars = reducerStruct.find { ($0.typeName?.isModuleReducer ?? false) && $0.kind == .`var` }
        
        // Insert module import
        let selectorString = "import \(reducerVars.last?.typeName?.name.replacingOccurrences(of: "Reducer", with: "") ?? "Core")".br
        var insertedCharacterCount = fileHandler.insert(content: "import \(moduleName.typeName)\(reducerVars.count > 0 ? .br : "")",
                                                        atOffset: 0,
                                                        withSelector: .matching(string: selectorString, insert: .after),
                                                        inFileAtPath: path)
        
        let varOffset = reducerVars.last?.offset ?? reducerStruct.offset
        
        // Insert module reducer var
        insertedCharacterCount += fileHandler.insert(content: "let \(moduleName.varName): \(moduleName.typeName)Reducer".indented.br,
                                                     atOffset: varOffset + insertedCharacterCount,
                                                     withSelector: .matching(string: .br, insert: .after),
                                                     inFileAtPath: path)
        
        guard let handleMethod = reducerStruct.find(recursive: true, isMatching: {
            $0.typeName == .beaverReducingHandleMethod
        }).first as? SwiftSubstructure else {
            fatalError("Couldn't find switch in \(SwiftTypeName.beaverReducingHandleMethod.name) in \(fileHandler)")
        }
        
        // Insert module action case
        _ = fileHandler.insert(content: moduleActionCase([moduleName]).indented(count: 2).br(2),
                               atOffset: handleMethod.offset + insertedCharacterCount,
                               withSelector: .matching(string: "return newState".indented(count: 2), insert: .before),
                               inFileAtPath: path)
        
        return AppReducer(moduleNames: moduleNames + [moduleName])
    }
}
