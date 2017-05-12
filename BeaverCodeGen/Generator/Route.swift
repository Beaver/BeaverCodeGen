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
        s << Enum(name: "\(moduleName.typeName)Route",
                  isPublic: true,
                  enumCases: routeCases,
                  implementing: ["Beaver.Route"]).description
        s << ""
        s << Enum(name: "\(moduleName.typeName)RouteSuccess",
                  isPublic: true,
                  enumCases: successCases,
                  implementing: ["Beaver.RouteSuccess"]).description
        s << ""
        s << Enum(name: "\(moduleName.typeName)RouteError",
                  isPublic: true,
                  enumCases: errorCases,
                  implementing: ["Beaver.RouteError"]).description
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