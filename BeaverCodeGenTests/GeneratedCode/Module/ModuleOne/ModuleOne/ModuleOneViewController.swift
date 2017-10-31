import Beaver
import Core

#if os(iOS)

final class ModuleOneViewController: Beaver.ViewController<ModuleOneState, AppState> {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let label = UILabel(frame: view.bounds)
        label.textAlignment = .center
        label.text = "Hello World!"

        view.addSubview(label)
    }

    override func stateDidUpdate(oldState: ModuleOneState?,
                                 newState: ModuleOneState,
                                 completion: @escaping () -> ()) {

        // Update the UI here

        completion()
    }
}

#endif
