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
        
        // Update the state here
        
        return newState
    }
}
