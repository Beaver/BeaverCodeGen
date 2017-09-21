import Beaver

public final class ModuleOnePresenter: Beaver.Presenting, Beaver.ChildStoring {
    public typealias StateType = ModuleOneState
    public typealias ParentStateType = AppState

    public let store: ChildStore<ModuleOneState, AppState>

    public let context: Context

    public init(store: ChildStore<ModuleOneState, AppState>,
                context: Context) {
        self.store = store
        self.context = context
    }
}

extension ModuleOnePresenter {
    public func stateDidUpdate(oldState: ModuleOneState?,
                               newState: ModuleOneState,
                               completion: @escaping () -> ()) {

        // Present the stages or emit to the parent router here

        completion()
    }
}
