struct Route {
    let moduleName: String
}

extension Route: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "public enum \(moduleName)Route: Beaver.Route {"
        s <<< "case open"
        s << "}"
        s << ""
        s << "public enum \(moduleName)RouteSuccess: RouteSuccess {"
        s << "}"
        s << ""
        s << "public enum \(moduleName)RouteError: RouteError {"
        s << "}"
        s << ""
        s << "extension \(moduleName)Route {"
        s <<< "public typealias RouteSuccessType = \(moduleName)RouteSuccess"
        s << ""
        s <<< "public typealias RouteErrorType = \(moduleName)RouteError"
        s << "}"
        s << ""
        s << "extension \(moduleName)Route {"
        s <<< "public static func ==(lhs: \(moduleName)Route, rhs: \(moduleName)Route) -> Bool {"
        s <<< tab("return true")
        s <<< "}"
        s += "}"

        return s
    }
}
