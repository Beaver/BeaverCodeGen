import Beaver

public struct ModuleState: Beaver.State {
    var error: String?

    var loading: Bool = false

    var currentScreen: CurrentScreen = .none
    
    public init() {
    }
}

extension ModuleState {
    /// Represents the currently shown screen
    enum CurrentScreen: Int {
        case none
        case main
    }
}

extension ModuleState {
    public static func ==(lhs: ModuleState, rhs: ModuleState) -> Bool {
        return lhs.error == rhs.error &&
                lhs.loading == rhs.loading &&
                lhs.currentScreen == rhs.currentScreen
    }
}
