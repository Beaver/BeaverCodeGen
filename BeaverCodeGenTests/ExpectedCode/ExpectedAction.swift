import Beaver

enum ExpectedAction: Beaver.Action {
    case open // Opens the main controller of the module
}

extension ExpectedAction {
    typealias StateType = ExpectedState
    typealias RouteType = ExpectedRoute
}

extension ExpectedAction {
    static func mapRouteToAction(from route: ExpectedRoute) -> ExpectedAction {
        switch route {
        case .open:
            return .open
        }
    }
}