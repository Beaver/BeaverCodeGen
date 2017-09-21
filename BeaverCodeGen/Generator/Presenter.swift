struct Presenter {
    let moduleName: String
}

extension Presenter: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "public final class \(moduleName.typeName)Presenter: Beaver.Presenting, Beaver.ChildStoring ".scope {
            var s = ""

            s << "public typealias StateType = \(moduleName.typeName)State"
            s << "public typealias ParentStateType = AppState"
            s << ""
            s << "public let store: ChildStore<\(moduleName.typeName)State, AppState>"
            s << ""
            s << "public let context: Context"
            s << ""
            s << "public init(store: ChildStore<\(moduleName.typeName)State, AppState>,"
            s += "            context: Context) ".scope {
                var s = ""

                s << "self.store = store"
                s += "self.context = context"

                return s
            }
            return s
        }
        s << ""
        s << "extension \(moduleName.typeName)Presenter ".scope {
            var s = ""

            s << "public func stateDidUpdate(oldState: \(moduleName.typeName)State?,"
            s << "                           newState: \(moduleName.typeName)State,"
            s += "                           completion: @escaping () -> ()) ".scope {
                var s = ""

                s << ""
                s << "// Present the stages or emit to the parent router here"
                s << ""
                s += "completion()"

                return s
            }

            return s
        }

        return s
    }
}
