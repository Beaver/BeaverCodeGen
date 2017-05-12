struct Action {
    let moduleName: String
}

extension Action: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "enum \(moduleName.typeName)Action: Beaver.Action {"
        s <<< "case open \(comment("Opens the main controller of the module"))"
        s << "}"
        s << ""
        s << "extension \(moduleName.typeName)Action {"
        s <<< "typealias StateType = \(moduleName.typeName)State"
        s <<< "typealias RouteType = \(moduleName.typeName)Route"
        s << "}"
        s << ""
        s << "extension \(moduleName.typeName)Action {"
        s <<< "static func mapRouteToAction(from route: \(moduleName.typeName)Route) -> \(moduleName.typeName)Action {"
        s <<< tab("switch route {")
        s <<< tab("case .open:")
        s <<< tab(.tab + "return .open")
        s <<< tab("}")
        s <<< "}"
        s += "}"

        return s
    }
}