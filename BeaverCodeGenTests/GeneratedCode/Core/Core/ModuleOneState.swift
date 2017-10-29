import Beaver

public struct ModuleOneState: Beaver.State {
    public var error: String?

    public var currentScreen: CurrentScreen = .none

    public init() {
    }
}

extension ModuleOneState {
    /// Represents the currently shown screen
    public enum CurrentScreen: Int {
        case none
        case main
    }
}

extension ModuleOneState {
    public static func ==(lhs: ModuleOneState, rhs: ModuleOneState) -> Bool {
        return lhs.error == rhs.error &&
            lhs.currentScreen == rhs.currentScreen
    }
}
