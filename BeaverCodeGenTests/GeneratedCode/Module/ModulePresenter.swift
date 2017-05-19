import Beaver

final class ModulePresenter: Beaver.Presenting {
    typealias StateType = ModuleState
    typealias ParentStateType = AppState

    let store: ChildStore<ModuleState, AppState>

    let context: Context

    init(store: ChildStore<ModuleState, AppState>,
         context: Context) {
        self.store = store
        self.context = context
    }
}

extension ModulePresenter {
    func stateDidUpdate(oldState: ModuleState?,
                        newState: ModuleState,
                        completion: @escaping () -> ()) {

        // Present the stages or emit to the parent router here

        completion()
    }
}