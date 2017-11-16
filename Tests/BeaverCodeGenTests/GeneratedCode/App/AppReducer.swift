import Beaver
import Core
import ModuleOne
import ModuleTwo

struct AppReducer: Beaver.Reducing {
    let moduleOne: ModuleOneReducer
    let moduleTwo: ModuleTwoReducer

    typealias StateType = AppState

    func handle(envelop: ActionEnvelop,
                state: AppState,
                completion: @escaping (AppState) -> ()) -> AppState {
        var newState = state

        switch envelop.action {
        case AppAction.start(let startAction):
            return handle(envelop: envelop.update(action: startAction), state: newState, completion: completion)

        case is ModuleOneAction:
            newState.moduleOneState = moduleOne.handle(envelop: envelop, state: state.moduleOneState ?? ModuleOneState()) { moduleOneState in
                newState.moduleOneState = moduleOneState
                completion(newState)
            }

        case AppAction.stop(module: ModuleOneRoutingAction.stop):
            newState.moduleOneState = nil

        case is ModuleTwoAction:
            newState.moduleTwoState = moduleTwo.handle(envelop: envelop, state: state.moduleTwoState ?? ModuleTwoState()) { moduleTwoState in
                newState.moduleTwoState = moduleTwoState
                completion(newState)
            }

        case AppAction.stop(module: ModuleTwoRoutingAction.stop):
            newState.moduleTwoState = nil

        default: break
        }

        return newState
    }
}
