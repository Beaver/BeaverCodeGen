import Beaver

final class ExpectedPresenter: Beaver.Presenting {
    typealias ActionType = ExpectedAction

    weak var weakStore: Store<ExpectedAction>?

    let parentRouter: Router<AppRoute>

    let context: Context

    let initialState: ExpectedState

    // Register your middlewares here
    let middlewares: [Store<ExpectedAction>.Middleware]

    init(parentRouter: Router<AppRoute>,
         context: Context,
         initialState: ExpectedState,
         middlewares: [Store<ExpectedAction>.Middleware]) {
        self.parentRouter = parentRouter
        self.context = context
        self.initialState = initialState
        self.middlewares = middlewares
    }
}

extension ExpectedPresenter {
    func stateDidUpdate(oldState: ExpectedState?,
                        newState: ExpectedState,
                        completion: @escaping () -> ()) {

        // Present the stages or emit to the parent router here

        completion()
    }
}