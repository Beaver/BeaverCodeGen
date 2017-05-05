import Beaver

public enum ExpectedRoute: Beaver.Route {
    case open
}

public enum ExpectedRouteSuccess: RouteSuccess {
}

public enum ExpectedRouteError: RouteError {
}

extension ExpectedRoute {
    public typealias RouteSuccessType = ExpectedRouteSuccess

    public typealias RouteErrorType = ExpectedRouteError
}

extension ExpectedRoute {
    public static func ==(lhs: ExpectedRoute, rhs: ExpectedRoute) -> Bool {
        return true
    }
}