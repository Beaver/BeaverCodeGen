import Beaver
import Core

#if os(iOS)
    
    final class ModuleTwoViewController: Beaver.ViewController<ModuleTwoState, AppState, ModuleTwoUIAction> {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            let label = UILabel(frame: view.bounds)
            label.textAlignment = .center
            label.text = "Hello World!"
            
            view.addSubview(label)
        }
        
        override func stateDidUpdate(oldState: ModuleTwoState?,
                                     newState: ModuleTwoState,
                                     completion: @escaping () -> ()) {
            
            // Update the UI here
            
            completion()
        }
    }
    
#endif
