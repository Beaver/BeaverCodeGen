struct ViewController: SwiftGenerating {
    let objectType: ObjectType = .viewController
    let moduleName: String
}

extension ViewController {
    var name: String {
        return moduleName
    }
    
    var description: String {
        return """
        import Beaver
        import Core
        
        #if os(iOS)
        
        final class \(moduleName.typeName)ViewController: Beaver.ViewController<\(moduleName.typeName)State, AppState> {
            override func stateDidUpdate(oldState: \(moduleName.typeName)State?,
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
