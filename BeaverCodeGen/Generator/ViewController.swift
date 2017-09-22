struct ViewController {
    let moduleName: String
}

extension ViewController: CustomStringConvertible {
    public var description: String {
        return """
        import Beaver
        
        #if os(iOS)
        
        final class \(moduleName.typeName)ViewController: Beaver.ViewController<\(moduleName.typeName)Action> {
            func stateDidUpdate(oldState: \(moduleName.typeName)State?,
                                newState: \(moduleName.typeName)State,
                                completion: @escaping () -> ()) {

                // Update the UI here
        
                completion()
            }
        }
        
        #endif
        
        """
    }
}
