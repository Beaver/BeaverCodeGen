import Beaver

#if os(iOS)

final class ModuleViewController: Beaver.ViewController<ModuleAction> {
    func stateDidUpdate(oldState: ModuleState?,
                        newState: ModuleState,
                        completion: @escaping () -> ()) {

        // Update the UI here

        completion()
    }
}

#endif