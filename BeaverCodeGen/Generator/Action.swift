struct ModuleAction {
    let moduleName: String
}

extension ModuleAction: CustomStringConvertible {
    var description: String {
        return """
        import Beaver
        
        public protocol \(moduleName.typeName)Action: Beaver.Action {
        }
        
        public enum \(moduleName.typeName)RoutingAction: \(moduleName.typeName)Action {
            case start
            case stop
        }
        
        enum \(moduleName.typeName)UIAction: \(moduleName.typeName)Action {
            case finish
        }
        
        """
    }
}

struct AppAction {
}

extension AppAction: CustomStringConvertible {
    var description: String {
        return """
        import Beaver
        
        enum AppAction: Beaver.Action {
            case start(module: Action)
            case stop(module: Action)
        }
        
        """
    }
}
