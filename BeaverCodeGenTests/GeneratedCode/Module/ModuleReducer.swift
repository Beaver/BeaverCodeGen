import Beaver

struct ModuleReducer: Beaver.Reducing {
    typealias StateType = ModuleState

    func handle(envelop: ActionEnvelop,
                state: ModuleState,
                completion: @escaping (ModuleState) -> ()) -> ModuleState {
        var newState = state

        // Update the state here

        return newState
    }
}