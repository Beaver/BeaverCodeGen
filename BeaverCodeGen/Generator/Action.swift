struct ModuleAction: Generating {
    let objectType: ObjectType = .action
    let moduleName: String
}

extension ModuleAction {
    var name: String {
        return moduleName
    }

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

struct AppAction: Generating {
    let objectType: ObjectType = .action
    let name = "App"
}

extension AppAction {
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
