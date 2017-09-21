import Beaver

#if os(iOS)
import UIKit
#endif

final class ModulesContainer {
    var moduleOne: ModuleOnePresenter?
    var moduleTwo: ModuleTwoPresenter?
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
        let reducer = AppReducer(module: ModuleReducer()).reducer
        let store = Store<AppState>(initialState: state, middlewares: middlewares, reducer: reducer)
        let presenter = AppPresenter(context: context, store: store)
        
        presenter.subscribe()
        presenter.dispatch(AppAction.start(withFirstAction: ModuleRoutingAction.start), recipients: .emitter)
        
        return (window, presenter)
    }
}

#endif

extension AppPresenter {
    func stateDidUpdate(oldState: AppState?,
                        newState: AppState,
                        completion: @escaping () -> ()) {
        switch (oldState?.moduleOneState, newState.moduleOneState) {
        case (.none, .some):
            let childStore = ChildStore(store: store) { $0.moduleOneState }
            modules.moduleOne = ModuleOnePresenter(store: childStore, context: context)
            modules.moduleOne?.subscribe()

        case (.some, .none):
            modules.moduleOne?.unsubscribe()
            modules.moduleOne = nil
            
        default: break
        }
        
        switch (oldState?.moduleTwoState, newState.moduleTwoState) {
        case (.none, .some):
            let childStore = ChildStore(store: store) { $0.moduleTwoState }
            modules.moduleTwo = ModuleTwoPresenter(store: childStore, context: context)
            modules.moduleTwo?.subscribe()
            
        case (.some, .none):
            modules.moduleTwo?.unsubscribe()
            modules.moduleTwo = nil
            
        default: break
        }

        completion()
    }
}
