import Beaver

public struct ModuleTwoState: Beaver.State {
    public var error: String?
    
    public var currentScreen: CurrentScreen = .none
    
    public init() {
    }
}

extension ModuleTwoState {
    /// Represents the currently shown screen
    public enum CurrentScreen: Int {
        case none
        case main
    }
}

extension ModuleTwoState {
    public static func ==(lhs: ModuleTwoState, rhs: ModuleTwoState) -> Bool {
        return lhs.error == rhs.error &&
            lhs.currentScreen == rhs.currentScreen
    }
}

