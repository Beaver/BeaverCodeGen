import Beaver

extension Router {
    /// Public ExpectedRouter builder
    public static func expected(parentRouter: Router<AppRoute>,
                                context: Context,
                                initialState: ExpectedState = ExpectedState()) -> Router<ExpectedRoute> {
        return ExpectedPresenter(parentRouter: parentRouter,
                                 context: context,
                                 initialState: initialState,
                                 middlewares: [.logging]).router
    }
}

extension ExpectedPresenter: Routing {
    func handle(route: ExpectedRoute,
                file: String,
                function: String,
                line: Int,
                completion: @escaping Router<ExpectedRoute>.Completion) {
        completion(.success(.done))
    }
}
