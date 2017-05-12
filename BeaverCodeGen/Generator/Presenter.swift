struct Presenter {
    let moduleName: String
}

extension Presenter: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "final class \(moduleName.typeName)Presenter: Beaver.Presenting ".scope {
            var s = ""

            s << "typealias ActionType = \(moduleName.typeName)Action"
            s << ""
            s << "weak var weakStore: Store<\(moduleName.typeName)Action>?"
            s << ""
            s << "let parentRouter: Router<AppRoute>"
            s << ""
            s << "let context: Context"
            s << ""
            s << "let initialState: \(moduleName.typeName)State"
            s << ""
            s << "// Register your middlewares here"
            s << "let middlewares: [Store<\(moduleName.typeName)Action>.Middleware]"
            s << ""
            s << "init(parentRouter: Router<AppRoute>,"
            s << "     context: Context,"
            s << "     initialState: \(moduleName.typeName)State,"
            s += "     middlewares: [Store<\(moduleName.typeName)Action>.Middleware]) ".scope {
                var s = ""

                s << "self.parentRouter = parentRouter"
                s << "self.context = context"
                s << "self.initialState = initialState"
                s += "self.middlewares = middlewares"

                return s
            }
            return s
        }
        s << ""
        s += "extension \(moduleName.typeName)Presenter ".scope {
            var s = ""

            s << "func stateDidUpdate(oldState: \(moduleName.typeName)State?,"
            s << "                    newState: \(moduleName.typeName)State,"
            s += "                    completion: @escaping () -> ()) ".scope {
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