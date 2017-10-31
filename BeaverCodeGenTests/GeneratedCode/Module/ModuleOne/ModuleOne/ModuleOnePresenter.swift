import Beaver
import Core

public final class ModuleOnePresenter: Beaver.Presenting, Beaver.ChildStoring {
    public typealias StateType = ModuleOneState
    public typealias ParentStateType = AppState

    public let store: ChildStore<ModuleOneState, AppState>

    public let context: Context

    public init(store: ChildStore<ModuleOneState, AppState>,
                context: Context) {
        self.store = store
        self.context = context
    }
}

extension ModuleOnePresenter {
    public func stateDidUpdate(oldState: ModuleOneState?,
                               newState: ModuleOneState,
                               completion: @escaping () -> ()) {

        switch (oldState?.currentScreen ?? .none, newState.currentScreen) {
        case (.none, .main):
            #if os(iOS)
            let moduleOneController = ModuleOneViewController(store: store)
            context.present(controller: moduleOneController, completion: completion)
            #endif

        case (.main, .none):
            #if os(iOS)
            context.dismiss(completion: completion)
            #endif

        default:
            completion()
        }
    }
}
