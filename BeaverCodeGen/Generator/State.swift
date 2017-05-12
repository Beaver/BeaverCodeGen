struct State {
    let moduleName: String
}

extension State: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "struct \(moduleName.typeName)State: Beaver.State ".scope {
            var s = ""
            s << "var error: String?"
            s << ""
            s << "var loading: Bool = false"
            s << ""
            s += "var currentScreen: CurrentScreen = .none"
            return s
        }
        s << ""
        s << "extension \(moduleName.typeName)State ".scope {
            var s = ""
            s << "/// Represents the currently shown screen"
            s += "enum CurrentScreen: Int ".scope {
                var s = ""
                s << "case none"
                s += "case main"
                return s
            }
            return s
        }
        s << ""
        s += "extension \(moduleName.typeName)State ".scope {
            "public static func ==(lhs: \(moduleName.typeName)State, rhs: \(moduleName.typeName)State) -> Bool ".scope {
                var s = ""
                s << "return lhs.error == rhs.error &&"
                s << "        lhs.loading == rhs.loading &&"
                s += "        lhs.currentScreen == rhs.currentScreen"
                return s
            }
        }

        return s
    }
}
