import Beaver

public final class ModulePresenter: Beaver.Presenting, Beaver.ChildStoring {
    public typealias StateType = ModuleState
    public typealias ParentStateType = AppState

    public var store: ChildStore<ModuleState, AppState>

    public let context: Context

    public init(store: ChildStore<ModuleState, AppState>,
                context: Context) {
        self.store = store
        self.context = context
    }
}

extension ModulePresenter {
    public func stateDidUpdate(oldState: ModuleState?,
                               newState: ModuleState,
                               completion: @escaping () -> ()) {

        // Present the stages or emit to the parent router here

        completion()
    }
}
