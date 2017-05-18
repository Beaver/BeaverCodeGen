import Beaver

final class ModulePresenter: Beaver.Presenting {
    typealias ActionType = ModuleAction

    weak var weakStore: Store<ModuleAction>?

    let parentRouter: Router<AppRoute>

    let context: Context

    let initialState: ModuleState

    // Register your middlewares here
    let middlewares: [Store<ModuleAction>.Middleware]

    init(parentRouter: Router<AppRoute>,
         context: Context,
         initialState: ModuleState,
         middlewares: [Store<ModuleAction>.Middleware]) {
        self.parentRouter = parentRouter
        self.context = context
        self.initialState = initialState
        self.middlewares = middlewares
    }
}

extension ModulePresenter {
    func stateDidUpdate(oldState: ModuleState?,
                        newState: ModuleState,
                        completion: @escaping () -> ()) {

        // Present the stages or emit to the parent router here

        completion()
    }
}