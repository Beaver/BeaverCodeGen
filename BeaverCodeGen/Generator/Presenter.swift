struct Presenter {
    let moduleName: String
}

extension Presenter: CustomStringConvertible {
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
