struct Reducer {
    let moduleName: String
}

extension Reducer: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s += "struct \(moduleName.typeName)Reducer: Beaver.Reducing ".scope {
            var s = ""
            s << "typealias ActionType = \(moduleName.typeName)Action"
            s << ""
            s << "func handle(envelop: ActionEnvelop<\(moduleName.typeName)Action>,"
            s << "            state: \(moduleName.typeName)State,"
            s += "            completion: @escaping (\(moduleName.typeName)State) -> ()) -> \(moduleName.typeName)State ".scope {
                var s = ""
                s << "var newState = state"
                s << ""
                s << "// Update the state here"
                s << ""
                s += "return newState"
                return s
            }
            return s
        }

        return s
    }
}
