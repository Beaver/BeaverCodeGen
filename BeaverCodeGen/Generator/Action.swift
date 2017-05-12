struct Action {
    let moduleName: String
}

extension Action: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "enum \(moduleName.typeName)Action: Beaver.Action ".scope {
            "case open \(comment("Opens the main controller of the module"))"
        }
        s << ""
        s << "extension \(moduleName.typeName)Action ".scope {
            var s = ""
            s << "typealias StateType = \(moduleName.typeName)State"
            s += "typealias RouteType = \(moduleName.typeName)Route"
            return s
        }
        s << ""
        s += "extension \(moduleName.typeName)Action ".scope {
            "static func mapRouteToAction(from route: \(moduleName.typeName)Route) -> \(moduleName.typeName)Action ".scope {
                "switch route ".scope(indent: false) {
                    var s = ""
                    s << "case .open:"
                    s <<< "return .open"
                    return s
                }
            }
        }

        return s
    }
}