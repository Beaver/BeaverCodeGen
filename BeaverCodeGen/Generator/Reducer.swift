struct Reducer {
    let moduleName: String
}

extension Reducer: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "public struct \(moduleName.typeName)Reducer: Beaver.ChildReducing ".scope {
            var s = ""
            s << "public typealias ActionType = \(moduleName.typeName)Action"
            s << "public typealias StateType = \(moduleName.typeName)State"
            s << ""
            s << "public init() {"
            s << "}"
            s << ""
            s << "public func handle(action: \(moduleName.typeName)Action,"
            s << "                   state: \(moduleName.typeName)State,"
            s += "                   completion: @escaping (\(moduleName.typeName)State) -> ()) -> \(moduleName.typeName)State ".scope {
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
