import Beaver

#if os(iOS)
import UIKit
#endif

final class ModulesContainer {
    var module: ModulePresenter?
}

final class AppPresenter: Presenting, Storing {
    typealias StateType = AppState
    
    let store: Store<AppState>

    let context: Context

    fileprivate let modules = ModulesContainer()

    init(context: Context,
         store: Store<AppState>) {
        self.store = store
        self.context = context
    }
}

#if os(iOS)

extension AppPresenter {
    static func bootstrap(state: AppState = AppState(),
                          middlewares: [Store<AppState>.Middleware] = [.logging]) -> (UIWindow, AppPresenter) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        let context = NavigationContext(parent: WindowContext(window: window))
        let store = Store<AppState>(initialState: state, middlewares: middlewares, reducer: AppReducer(module: ModuleReducer()).reducer)
        let presenter = AppPresenter(context: context, store: store)

        presenter.dispatch(AppAction.start)

        return (window, presenter)
    }
}

#endif

extension AppPresenter {
    func stateDidUpdate(oldState: AppState?,
                        newState: AppState,
                        completion: @escaping () -> ()) {

        switch (oldState?.moduleState, newState.moduleState) {
        case (.none, .some):
            let childStore = ChildStore(store: store) { $0.moduleState }
            modules.module = ModulePresenter(store: childStore, context: context)
            modules.module?.subscribe()

        case (.some, .none):
            modules.module?.unsubscribe()
            modules.module = nil
            
        default: break
        }

        completion()
    }
}
