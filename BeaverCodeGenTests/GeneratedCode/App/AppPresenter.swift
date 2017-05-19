import Beaver

final class AppPresenter {
    let store = Beaver.Store<AppState>

    let context: Context

    init(context: Context,
         store: Beaver.Store<AppState>) {
        self.store = store
        self.context = context
    }
}

extension AppPresenter {
    func stateDidUpdate(oldState: AppState?,
                        newState: AppState,
                        completion: @escaping () -> ()) {
        completion()
    }
}