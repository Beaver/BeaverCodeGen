struct State {
    let moduleName: String
}

extension State: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "struct \(moduleName.typeName)State: Beaver.State {"
        s <<< "var error: String?"
        s << ""
        s <<< "var loading: Bool = false"
        s << ""
        s <<< "var currentScreen: CurrentScreen = .none"
        s << "}"
        s << ""
        s << "extension \(moduleName.typeName)State {"
        s <<< "/// Represents the currently shown screen"
        s <<< "enum CurrentScreen: Int {"
        s <<< tab("case none")
        s <<< tab("case main")
        s <<< "}"
        s << "}"
        s << ""
        s << "extension \(moduleName.typeName)State {"
        s <<< "public static func ==(lhs: \(moduleName.typeName)State, rhs: \(moduleName.typeName)State) -> Bool {"
        s <<< tab("return lhs.error == rhs.error &&")
        s <<< tab("        lhs.loading == rhs.loading &&")
        s <<< tab("        lhs.currentScreen == rhs.currentScreen")
        s <<< "}"
        s += "}"

        return s
    }
}
