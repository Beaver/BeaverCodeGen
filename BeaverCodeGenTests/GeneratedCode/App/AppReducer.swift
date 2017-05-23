import Beaver

struct AppReducer: Beaver.Reducing {
    typealias StateType = AppState

    let module: ModuleReducer

    func handle(envelop: ActionEnvelop,
                state: AppState,
                completion: @escaping (AppState) -> ()) -> AppState {
        var newState = state

        switch envelop.action {
        case AppAction.start(let startAction):
            return handle(envelop: envelop.update(action: startAction), state: AppState(), completion: completion)

        case AppAction.stop(module: ModuleRoutingAction.stop):
            
            newState.moduleState = nil

        case is ModuleRoutingAction:
            newState.moduleState = module.handle(envelop: envelop, state: state.moduleState ?? ModuleState()) { moduleState in
                newState.moduleState = moduleState
                completion(newState)
            }
            
        default: break
        }

        return newState
    }
}
