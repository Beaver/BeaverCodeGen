import Beaver

struct AppState: Beaver.State {
    var moduleState: ModuleState?
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.currentRoute == rhs.currentRoute
    }
}
