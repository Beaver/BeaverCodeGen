import Beaver

enum AppAction: Beaver.Action {
    case start(module: Action)
    case stop(module: Action)
}
