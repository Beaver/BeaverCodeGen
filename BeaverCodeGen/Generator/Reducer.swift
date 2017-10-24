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
    var moduleNames: [String]
}

extension AppReducer {
    var name: String {
        return "App"
    }
    
    var description: String {
        return """
        import Beaver
        
        struct AppReducer: Beaver.Reducing {
        \(moduleNames.count > 0 ? moduleNames.map {
            "let \($0.varName): \($0.typeName)Reducer"
        }.joined(separator: .br).indented.br : "")
            typealias StateType = AppState

            func handle(envelop: ActionEnvelop,
                        state: AppState,
                        completion: @escaping (AppState) -> ()) -> AppState {
                var newState = state
        
                switch envelop.action {
                case AppAction.start(let startAction):
                    return handle(envelop: envelop.update(action: startAction), state: AppState(), completion: completion)
        \(moduleNames.count > 0 ? .br + moduleActionCase(moduleNames).indented(count: 2).br : "")
                default: break
                }
        
                return newState
            }
        }
        
        """
    }
    
    private func moduleActionCase(_ moduleNames: [String]) -> String {
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
    
    func byInserting(module moduleName: String, in fileHandler: FileHandling) -> AppReducer {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)

        guard let reducerStruct = swiftFile.find(recursive: true, isMatching: {
            $0.typeName == .appReducer && $0.kind == .`struct` && $0.doesInherit(from: [.beaverReducing])
        }).first as? SwiftSubstructure else {
            fatalError("Couldn't find AppReducer in \(fileHandler)")
        }
        
        let reducerVars = reducerStruct.find { ($0.typeName?.isModuleReducer ?? false) && $0.kind == .`var` }
        let varOffset = reducerVars.last?.offset ?? reducerStruct.offset
        
        let insertedCharacterCount = fileHandler.insert(content: "let \(moduleName.varName): \(moduleName.typeName)Reducer".indented.br,
                                                        atOffset: varOffset,
                                                        withSelector: .matching(string: .br, insert: .after),
                                                        inFileAtPath: path)
        
        guard let handleSwitch = reducerStruct.find(recursive: true, isMatching: {
            $0.kind == .`switch` && $0.parent?.typeName == .beaverReducingHandleMethod
        }).first as? SwiftSubstructure else {
            fatalError("Couldn't find switch in \(SwiftTypeName.beaverReducingHandleMethod.name) in \(fileHandler)")
        }

        _ = fileHandler.insert(content: moduleActionCase([moduleName]).indented(count: 2).br(2),
                               atOffset: handleSwitch.offset + insertedCharacterCount,
                               withSelector: .matching(string: "default".indented(count: 2), insert: .before),
                               inFileAtPath: path)
        
        return AppReducer(moduleNames: moduleNames + [moduleName])
    }
}
