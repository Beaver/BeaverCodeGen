import Beaver

struct AppState: Beaver.State {
    var currentRoute: AppRoute

    var expectedState: ExpectedState?
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.currentRoute == rhs.currentRoute
    }
}
