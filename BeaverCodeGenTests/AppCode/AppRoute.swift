import Beaver

public enum AppRoute: Beaver.Route {
    case expected(ExpectedRoute)
}

public enum AppRouteSuccess: Beaver.RouteSuccess {
    case expected(ExpectedRouteSuccess)
}

public enum AppRouteError: Beaver.RouteError {
    case expected(ExpectedRouteError)
}

extension AppRoute {
    public typealias RouteSuccessType = AppRouteSuccess

    public typealias RouteErrorType = AppRouteError
}

extension AppRoute: Equatable {
    public static func ==(lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.expected(let expectedRoute1), .expected(let expectedRoute2)):
            return expectedRoute1 == expectedRoute2
        }
    }
}