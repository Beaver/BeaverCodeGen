import Beaver

public struct AppState: Beaver.State {
    public var moduleOneState: ModuleOneState?
    public var moduleTwoState: ModuleTwoState?

    public init() {
    }
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.moduleOneState == rhs.moduleOneState &&
            lhs.moduleTwoState == rhs.moduleTwoState
    }
}
