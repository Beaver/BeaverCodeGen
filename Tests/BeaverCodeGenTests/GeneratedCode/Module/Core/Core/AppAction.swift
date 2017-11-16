import Beaver

public enum AppAction: Beaver.Action {
    case start(module: Action)
    case stop(module: Action)
}
