import Beaver

enum AppAction: Beaver.Action {
    case route(AppRouteAction)
}

enum AppRouteAction {
    case expected(ExpectedRoute)
}

extension AppAction {
    static func mapRouteToAction(from route: AppRoute) -> AppAction {
        switch route {
        case .expected(let expectedRoute):
            return .route(.expected(expectedRoute))
        }
    }
}