import Beaver
import Core

public struct ModuleOneReducer: Beaver.ChildReducing {
    public typealias ActionType = ModuleOneAction
    public typealias StateType = ModuleOneState

    public init() {
    }

    public func handle(action: ModuleOneAction,
                       state: ModuleOneState,
                       completion: @escaping (ModuleOneState) -> ()) -> ModuleOneState {
        var newState = state

        switch action {
        case ModuleOneRoutingAction.start:
            newState.currentScreen = .main

        case ModuleOneRoutingAction.stop:
            newState.currentScreen = .none

        default:
            break
        }

        return newState
    }
}
