import Beaver
import Core

public struct ModuleTwoReducer: Beaver.ChildReducing {
    public typealias ActionType = ModuleTwoAction
    public typealias StateType = ModuleTwoState
    
    public init() {
    }
    
    public func handle(action: ModuleTwoAction,
                       state: ModuleTwoState,
                       completion: @escaping (ModuleTwoState) -> ()) -> ModuleTwoState {
        var newState = state

        switch ExhaustiveAction<ModuleTwoRoutingAction, ModuleTwoUIAction>(action) {
        case .routing:
            // handle routing action here
            break

        case .ui:
            // handle ui actions here
            break
        }
        
        return newState
    }
}
