import Beaver

public struct ModuleReducer: Beaver.ChildReducing {
    public typealias ActionType = ModuleAction
    public typealias StateType = ModuleState

    public init() {
    }

    public func handle(action: ModuleAction,
                       state: ModuleState,
                       completion: @escaping (ModuleState) -> ()) -> ModuleState {
        var newState = state

        // Update the state here

        return newState
    }
}
