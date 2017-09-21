import Beaver

public struct ModuleState: Beaver.State {
    public var error: String?

    public var currentScreen: CurrentScreen = .none

    public init() {
    }
}

extension ModuleState {
    /// Represents the currently shown screen
    public enum CurrentScreen: Int {
        case none
        case main
    }
}

extension ModuleState {
    public static func ==(lhs: ModuleState, rhs: ModuleState) -> Bool {
        return lhs.error == rhs.error &&
            lhs.currentScreen == rhs.currentScreen
    }
}
