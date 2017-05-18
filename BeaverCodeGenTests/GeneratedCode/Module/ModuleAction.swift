import Beaver

public protocol ModuleAction: Beaver.Action {
}

public enum ModuleRoutingAction: ModuleAction {
    case start
}

enum ModuleUIAction: ModuleAction {
    case finish
}
