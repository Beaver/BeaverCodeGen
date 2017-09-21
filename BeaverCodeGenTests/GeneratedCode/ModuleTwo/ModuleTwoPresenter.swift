import Beaver

public final class ModuleTwoPresenter: Beaver.Presenting, Beaver.ChildStoring {
    public typealias StateType = ModuleTwoState
    public typealias ParentStateType = AppState
    
    public let store: ChildStore<ModuleTwoState, AppState>
    
    public let context: Context
    
    public init(store: ChildStore<ModuleTwoState, AppState>,
                context: Context) {
        self.store = store
        self.context = context
    }
}

extension ModuleTwoPresenter {
    public func stateDidUpdate(oldState: ModuleTwoState?,
                               newState: ModuleTwoState,
                               completion: @escaping () -> ()) {
        
        // Present the stages or emit to the parent router here
        
        completion()
    }
}
