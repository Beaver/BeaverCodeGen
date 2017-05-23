import Beaver

public struct AppState: Beaver.State {
    var moduleState: ModuleState?

    public init() {
    }
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.moduleState == rhs.moduleState
    }
}
