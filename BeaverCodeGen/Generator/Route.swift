struct Route {
    let moduleName: String

    let routeCases: [EnumCase]

    let successCases: [EnumCase]

    let errorCases: [EnumCase]

    init(moduleName: String,
         routeCases: [EnumCase] = [EnumCase(name: "open")],
         successCases: [EnumCase] = [EnumCase(name: "done")],
         errorCases: [EnumCase] = [EnumCase(name: "unexpected")]) {
        self.moduleName = moduleName
        self.routeCases = routeCases
        self.successCases = successCases
        self.errorCases = errorCases
    }
}

extension Route: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "public enum \(moduleName.typeName)Route: Beaver.Route {"
        for routeCase in routeCases {
            s <<< routeCase.description
        }
        s << "}"
        s << ""
        s << "public enum \(moduleName.typeName)RouteSuccess: RouteSuccess {"
        for successCase in successCases {
            s <<< successCase.description
        }
        s << "}"
        s << ""
        s << "public enum \(moduleName.typeName)RouteError: RouteError {"
        for errorCase in errorCases {
            s <<< errorCase.description
        }
        s << "}"
        s << ""
        s << "extension \(moduleName.typeName)Route {"
        s <<< "public typealias RouteSuccessType = \(moduleName.typeName)RouteSuccess"
        s << ""
        s <<< "public typealias RouteErrorType = \(moduleName.typeName)RouteError"
        s << "}"
        s << ""
        s << "extension \(moduleName.typeName)Route: Equatable {"
        s <<< "public static func ==(lhs: \(moduleName.typeName)Route, rhs: \(moduleName.typeName)Route) -> Bool {"
        s <<< tab(CompareSwitch(enumCases: routeCases).description)
        s <<< "}"
        s += "}"

        return s
    }
}

struct AppRoute {
    let moduleNames: [String]
}

extension AppRoute: CustomStringConvertible {
    var description: String {
        return Route(moduleName: "App",
                     routeCases: moduleNames.map {
                         EnumCase(name: $0.varName, arguments: [(name: nil, "\($0.typeName)Route")])
                     },
                     successCases: moduleNames.map {
                         EnumCase(name: $0.varName, arguments: [(name: nil, "\($0.typeName)RouteSuccess")])
                     },
                     errorCases: moduleNames.map {
                         EnumCase(name: $0.varName, arguments: [(name: nil, "\($0.typeName)RouteError")])
                     }).description
    }
}