struct Reducer {
    let moduleName: String
}

extension Reducer: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "struct \(moduleName.typeName)Reducer: Beaver.Reducing {"
        s <<< "typealias ActionType = \(moduleName.typeName)Action"
        s << ""
        s <<< "func handle(envelop: ActionEnvelop<\(moduleName.typeName)Action>,"
        s <<< "            state: \(moduleName.typeName)State,"
        s <<< "            completion: @escaping (\(moduleName.typeName)State) -> ()) -> \(moduleName.typeName)State {"
        s <<< tab("var newState = state")
        s << ""
        s <<< tab("// Update the state here")
        s << ""
        s <<< tab("return newState")
        s <<< "}"
        s += "}"

        return s
    }
}
