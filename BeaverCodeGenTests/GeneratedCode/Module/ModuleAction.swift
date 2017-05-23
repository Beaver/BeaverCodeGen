import Beaver

public protocol ModuleAction: Beaver.Action {
}

public enum ModuleRoutingAction: ModuleAction {
    case start
    case stop
}

enum ModuleUIAction: ModuleAction {
    case finish
}
