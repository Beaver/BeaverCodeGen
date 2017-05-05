struct State {
    let moduleName: String
}

extension State: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "struct \(moduleName)State: Beaver.State {"
        s <<< "var error: String?"
        s << ""
        s <<< "var loading: Bool = false"
        s << ""
        s <<< "var currentScreen: CurrentScreen = .none"
        s << "}"
        s << ""
        s << "extension \(moduleName)State {"
        s <<< "/// Represents the currently shown screen"
        s <<< "enum CurrentScreen: Int {"
        s <<< tab("case none")
        s <<< tab("case main")
        s <<< "}"
        s << "}"
        s << ""
        s << "extension \(moduleName)State {"
        s <<< "public static func ==(lhs: \(moduleName)State, rhs: \(moduleName)State) -> Bool {"
        s <<< tab("return true")
        s <<< "}"
        s += "}"

        return s
    }
}
