import Beaver

struct ModuleReducer: Beaver.Reducing {
    typealias ActionType = ModuleAction

    func handle(envelop: ActionEnvelop<ModuleAction>,
                state: ModuleState,
                completion: @escaping (ModuleState) -> ()) -> ModuleState {
        var newState = state

        // Update the state here

        return newState
    }
}