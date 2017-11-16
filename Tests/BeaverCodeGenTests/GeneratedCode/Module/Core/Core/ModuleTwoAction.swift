import Beaver

public protocol ModuleTwoAction: Beaver.Action {
}

public enum ModuleTwoRoutingAction: ModuleTwoAction {
    case start
    case stop
}
