struct Reducer {
    let moduleName: String
}

extension Reducer: CustomStringConvertible {
    public var description: String {
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
