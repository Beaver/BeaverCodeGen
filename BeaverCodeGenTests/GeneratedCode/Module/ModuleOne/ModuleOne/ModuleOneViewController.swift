import Beaver
import Core

#if os(iOS)

final class ModuleOneViewController: Beaver.ViewController<ModuleOneState, AppState> {
    override func stateDidUpdate(oldState: ModuleOneState?,
                                 newState: ModuleOneState,
                                 completion: @escaping () -> ()) {

        // Update the UI here

        completion()
    }
}

#endif
