import Beaver

#if os(iOS)

final class ModuleOneViewController: Beaver.ViewController<ModuleOneAction> {
    func stateDidUpdate(oldState: ModuleOneState?,
                        newState: ModuleOneState,
                        completion: @escaping () -> ()) {

        // Update the UI here

        completion()
    }
}

#endif
