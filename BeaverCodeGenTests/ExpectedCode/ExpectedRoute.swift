import Beaver

public enum ExpectedRoute: Beaver.Route {
    case open
}

public enum ExpectedRouteSuccess: RouteSuccess {
    case done
}

public enum ExpectedRouteError: RouteError {
    case unexpected
}

extension ExpectedRoute {
    public typealias RouteSuccessType = ExpectedRouteSuccess

    public typealias RouteErrorType = ExpectedRouteError
}

extension ExpectedRoute: Equatable {
    public static func ==(lhs: ExpectedRoute, rhs: ExpectedRoute) -> Bool {
        switch (lhs, rhs) {
        case (.open, .open):
            return true
        }
    }
}