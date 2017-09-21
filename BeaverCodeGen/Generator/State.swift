struct State {
    let moduleName: String
}

extension State: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "public struct \(moduleName.typeName)State: Beaver.State ".scope {
            var s = ""
            s << "public var error: String?"
            s << ""
            s << "public var currentScreen: CurrentScreen = .none"
            s << ""
            s << "public init() {"
            s += "}"
            return s
        }
        s << ""
        s << "extension \(moduleName.typeName)State ".scope {
            var s = ""
            s << "/// Represents the currently shown screen"
            s += "public enum CurrentScreen: Int ".scope {
                var s = ""
                s << "case none"
                s += "case main"
                return s
            }
            return s
        }
        s << ""
        s << "extension \(moduleName.typeName)State ".scope {
            "public static func ==(lhs: \(moduleName.typeName)State, rhs: \(moduleName.typeName)State) -> Bool ".scope {
                var s = ""
                s << "return lhs.error == rhs.error &&"
                s += "    lhs.currentScreen == rhs.currentScreen"
                return s
            }
        }

        return s
    }
}
