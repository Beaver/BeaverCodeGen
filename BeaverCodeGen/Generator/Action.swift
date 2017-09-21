struct Action {
    let moduleName: String
}

extension Action: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "public protocol ModuleAction: Beaver.Action {"
        s << "}"
        s << ""
        s << "public enum \(moduleName.typeName)RoutingAction: ModuleAction ".scope {
            var s = ""
            s << "case start"
            s += "case stop"
            return s
        }
        s << ""
        s << "enum ModuleUIAction: ModuleAction ".scope {
            "case finish"
        }
        
        return s
    }
}
