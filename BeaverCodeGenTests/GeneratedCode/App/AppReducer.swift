import Beaver

struct AppReducer: Beaver.Reducing {
    typealias StateType = AppState

    func handle(envelop: ActionEnvelop,
                state: AppState,
                completion: @escaping (AppState) -> ()) -> AppState {
        var newState = state

        switch envelop.action {
        case is ModuleRoutingAction:
            newState.moduleState = ModuleReducer().handle(envelop: envelop, state: state.moduleState ?? ModuleState()) { moduleState in
                newState.moduleState = moduleState
                completion(newState)
            }
            
        default: break
        }

        return newState
    }
}
