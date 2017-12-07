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

        // Reduce start action

        if case AppAction.start(let startAction) = envelop.action {
            return handle(envelop: envelop.update(action: startAction), state: newState, completion: completion)
        }

        // Reduce ModuleOne's actions

        if envelop.action is ModuleOneAction {
            newState.moduleOneState = moduleOne.handle(envelop: envelop, state: state.moduleOneState ?? ModuleOneState()) { moduleOneState in
                newState.moduleOneState = moduleOneState
                completion(newState)
            }
        }

        if case AppAction.stop(module: ModuleOneRoutingAction.stop) = envelop.action {
            newState.moduleOneState = nil
        }

        // Reduce ModuleTwo's actions

        if envelop.action is ModuleTwoAction {
            newState.moduleTwoState = moduleTwo.handle(envelop: envelop, state: state.moduleTwoState ?? ModuleTwoState()) { moduleTwoState in
                newState.moduleTwoState = moduleTwoState
                completion(newState)
            }
        }

        if case AppAction.stop(module: ModuleTwoRoutingAction.stop) = envelop.action {
            newState.moduleTwoState = nil
        }

        return newState
    }
}
