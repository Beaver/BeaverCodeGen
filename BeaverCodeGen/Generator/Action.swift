struct Action {
    let moduleName: String
}

extension Action: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "enum \(moduleName)Action: Beaver.Action {"
        s <<< "case open \(comment("Opens the main controller of the module"))"
        s << "}"
        s << ""
        s << "extension \(moduleName)Action {"
        s <<< "typealias StateType = \(moduleName)State"
        s <<< "typealias RouteType = \(moduleName)Route"
        s << "}"
        s << ""
        s << "extension \(moduleName)Action {"
        s <<< "static func mapRouteToAction(from route: \(moduleName)Route) -> \(moduleName)Action {"
        s <<< tab("switch route {")
        s <<< tab("case .open:")
        s <<< tab(.tab + "return .open")
        s <<< tab("}")
        s <<< "}"
        s += "}"

        return s
    }
}