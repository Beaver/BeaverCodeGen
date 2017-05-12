struct ViewController {
    let moduleName: String
}

extension ViewController: CustomStringConvertible {
    public var description: String {
        var s = ""

        s << "import Beaver"
        s << ""
        s << "#if os(iOS)"
        s << ""
        s << "final class \(moduleName.typeName)ViewController: Beaver.ViewController<\(moduleName.typeName)Action> ".scope {
            var s = ""
            s << "func stateDidUpdate(oldState: \(moduleName.typeName)State?,"
            s << "                    newState: \(moduleName.typeName)State,"
            s += "                    completion: @escaping () -> ()) ".scope {
                var s = ""
                s << ""
                s << "// Update the UI here"
                s << ""
                s += "completion()"
                return s
            }
            return s
        }
        s << ""
        s += "#endif"

        return s
    }
}