import Beaver

#if os(iOS)
    
    final class ModuleTwoViewController: Beaver.ViewController<ModuleTwoAction> {
        func stateDidUpdate(oldState: ModuleTwoState?,
                            newState: ModuleTwoState,
                            completion: @escaping () -> ()) {
            
            // Update the UI here
            
            completion()
        }
    }
    
#endif

