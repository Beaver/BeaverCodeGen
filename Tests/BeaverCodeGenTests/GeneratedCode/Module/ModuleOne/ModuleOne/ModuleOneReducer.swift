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

        switch ExhaustiveAction<ModuleOneRoutingAction, ModuleOneUIAction>(action) {
        case .routing(.start):
            newState.currentScreen = .main

        case .routing(.stop):
            newState.currentScreen = .none

        case .ui:
            break
        }

        return newState
    }
}
