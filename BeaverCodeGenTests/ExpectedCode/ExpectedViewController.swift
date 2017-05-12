import Beaver

#if os(iOS)

final class ExpectedViewController: Beaver.ViewController<ExpectedAction> {
    func stateDidUpdate(oldState: ExpectedState?,
                        newState: ExpectedState,
                        completion: @escaping () -> ()) {

        // Update the UI here

        completion()
    }
}

#endif