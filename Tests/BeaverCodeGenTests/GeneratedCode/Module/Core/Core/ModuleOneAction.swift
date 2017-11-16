import Beaver

public protocol ModuleOneAction: Beaver.Action {
}

public enum ModuleOneRoutingAction: ModuleOneAction {
    case start
    case stop
}
