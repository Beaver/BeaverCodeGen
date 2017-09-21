import Beaver

public struct ModuleOneReducer: Beaver.ChildReducing {
    public typealias ActionType = ModuleOneAction
    public typealias StateType = ModuleOneState

    public init() {
    }

    public func handle(action: ModuleOneAction,
                       state: ModuleOneState,
                       completion: @escaping (ModuleOneState) -> ()) -> ModuleOneState {
        var newState = state

        // Update the state here

        return newState
    }
}
