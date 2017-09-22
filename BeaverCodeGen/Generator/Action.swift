struct Action {
    let moduleName: String
}

extension Action: CustomStringConvertible {
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
