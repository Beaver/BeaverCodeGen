import Beaver

struct AppState: Beaver.State {
    var expectedState: ExpectedState?
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return true
    }
}
