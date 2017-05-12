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
        s << "final class \(moduleName.typeName)ViewController: Beaver.ViewController<\(moduleName.typeName)Action> {"
        s <<< "func stateDidUpdate(oldState: \(moduleName.typeName)State?,"
        s <<< "                    newState: \(moduleName.typeName)State,"
        s <<< "                    completion: @escaping () -> ()) {"
        s << ""
        s <<< tab("// Update the UI here")
        s << ""
        s <<< tab("completion()")
        s <<< "}"
        s << "}"
        s << ""
        s += "#endif"

        return s
    }
}