import Beaver

public struct ModuleReducer: Beaver.Reducing {
    public typealias StateType = ModuleState

    public func handle(envelop: ActionEnvelop,
                       state: ModuleState,
                       completion: @escaping (ModuleState) -> ()) -> ModuleState {
        var newState = state

        // Update the state here

        return newState
    }
}