struct ModuleReducer: Generating {
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
        
        public struct \(moduleName.typeName)Reducer: Beaver.ChildReducing {
            public typealias ActionType = \(moduleName.typeName)Action
            public typealias StateType = \(moduleName.typeName)State
        
            public init() {
            }
        
            public func handle(action: \(moduleName.typeName)Action,
                               state: \(moduleName.typeName)State,
                               completion: @escaping (\(moduleName.typeName)State) -> ()) -> \(moduleName.typeName)State {
                var newState = state
        
                // Update the state here
        
                return newState
            }
        }
        
        """
    }
}


struct AppReducer: Generating {
    let objectType: ObjectType = .reducer
    let moduleNames: [String]
}

extension AppReducer {
    var name: String {
        return "App"
    }
    
    var description: String {
        return """
        import Beaver
        
        struct AppReducer: Beaver.Reducing {
            typealias StateType = AppState
        
            \(moduleNames.map {
                "let \($0.varName): \($0.typeName)Reducer"
            }.joined(separator: br(.tab)))
        
            func handle(envelop: ActionEnvelop,
                        state: AppState,
                        completion: @escaping (AppState) -> ()) -> AppState {
                var newState = state
        
                switch envelop.action {
                case AppAction.start(let startAction):
                    return handle(envelop: envelop.update(action: startAction), state: AppState(), completion: completion)

        \(moduleActionCase.indented(count: 2))
        
                default: break
                }
        
                return newState
            }
        }
        
        """
    }
    
    private var moduleActionCase: String {
        return moduleNames.map {
            """
            case is \($0.typeName)Action:
                newState.\($0.varName)State = \($0.varName).handle(envelop: envelop, state: state.\($0.varName)State ?? \($0.typeName)State()) { \($0.varName)State in
                    newState.\($0.varName)State = \($0.varName)State
                    completion(newState)
                }
            
            case AppAction.stop(module: \($0.typeName)RoutingAction.stop):
                newState.\($0.varName)State = nil
            """
        }.joined(separator: .br(2))
    }
}
