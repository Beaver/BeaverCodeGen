import Beaver

struct ExpectedReducer: Beaver.Reducing {
    typealias ActionType = ExpectedAction

    func handle(envelop: ActionEnvelop<ExpectedAction>,
                state: ExpectedState,
                completion: @escaping (ExpectedState) -> ()) -> ExpectedState {
        var newState = state

        // Update the state here

        return newState
    }
}