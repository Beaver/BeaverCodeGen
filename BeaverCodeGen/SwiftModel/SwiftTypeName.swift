enum SwiftTypeName {
    case beaverAction
    case moduleAction(moduleName: String)
    case moduleUIAction(moduleName: String)
    case moduleRoutingAction(moduleName: String)
    case appAction
    case appActionStop
    case beaverState
    case appState
    case moduleState(moduleName: String)
    case equalOperator
    case appReducer
    case beaverReducing
    case beaverReducingHandleMethod
    case moduleReducer(moduleName: String)
    case modulesContainer
    case modulePresenter(moduleName: String)
    case appPresenter
    case appPresenterBootstrapMethod
    case presentingStateDidUpdateMethod
    case unknown(name: String)
}

extension SwiftTypeName: Decodable {
    init(from decoder: Decoder) throws {
        let name: String = try {
            if let values = try? decoder.container(keyedBy: CodingKeys.self) {
                return try values.decode(String.self, forKey: .name)
            } else {
                return try decoder.singleValueContainer().decode(String.self)
            }
        }()
        switch name {
        case "^(Beaver\\.)?Action$":
            self = .beaverAction
        case ".*UIAction$":
            self = .moduleUIAction(moduleName: name.replacingOccurrences(of: "UIAction", with: ""))
        case ".*RoutingAction$":
            self = .moduleRoutingAction(moduleName: name.replacingOccurrences(of: "RoutingAction", with: ""))
        case _ where name == "AppAction":
            self = .appAction
        case _ where name == "AppAction.stop":
            self = .appActionStop
        case ".*Action$":
            self = .moduleAction(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"Action".characters.count)]))
        case "^(Beaver\\.)?State$":
            self = .beaverState
        case _ where name == "AppState":
            self = .appState
        case ".*State$":
            self = .moduleState(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"State".characters.count)]))
        case _ where name == "==(_:_:)":
            self = .equalOperator
        case _ where name == "AppReducer":
            self = .appReducer
        case "^(Beaver\\.)?Reducing$":
            self = .beaverReducing
        case _ where name == "handle(envelop:state:completion:)":
            self = .beaverReducingHandleMethod
        case ".*Reducer$":
            self = .moduleReducer(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"Reducer".characters.count)]))
        case _ where name == "ModulesContainer":
            self = .modulesContainer
        case _ where name == "AppPresenter":
            self = .appPresenter
        case ".*Presenter\\?$":
            self = .modulePresenter(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"Presenter?".characters.count)]))
        case ".*Presenter$":
            self = .modulePresenter(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"Presenter".characters.count)]))
        case _ where name == "bootstrap(state:middlewares:)":
            self = .appPresenterBootstrapMethod
        case _ where name == "stateDidUpdate(oldState:newState:completion:)":
            self = .presentingStateDidUpdateMethod
        default:
            self = .unknown(name: name)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "key.name"
    }
}

extension SwiftTypeName {
    var isModuleState: Bool {
        switch self {
        case .moduleState:
            return true
        default:
            return false
        }
    }
    
    var isModuleReducer: Bool {
        switch self {
        case .moduleReducer:
            return true
        default:
            return false
        }
    }
    
    var isModulePresenter: Bool {
        switch self {
        case .modulePresenter:
            return true
        default:
            return false
        }
    }
        
    var name: String {
        switch self {
        case .beaverAction:
            return "Beaver.Action"
        case .moduleAction(let moduleName):
            return "\(moduleName)Action"
        case .moduleUIAction(let moduleName):
            return "\(moduleName)UIAction"
        case .moduleRoutingAction(let moduleName):
            return "\(moduleName)RoutingAction"
        case .appAction:
            return "AppAction"
        case .appActionStop:
            return "AppAction.stop"
        case .beaverState:
            return "Beaver.State"
        case .appState:
            return "AppState"
        case .moduleState(let moduleName):
            return "\(moduleName)State"
        case .equalOperator:
            return "==(_:_:)"
        case .appReducer:
            return "AppReducer"
        case .beaverReducing:
            return "Beaver.Reducing"
        case .beaverReducingHandleMethod:
            return "Beaver.Reducing.handle(envelop:state:completion:)"
        case .moduleReducer(let moduleName):
            return "\(moduleName)Reducer"
        case .modulesContainer:
            return "ModulesContainer"
        case .modulePresenter(let moduleName):
            return "\(moduleName)Presenter"
        case .appPresenter:
            return "AppPresenter"
        case .appPresenterBootstrapMethod:
            return "AppPresenter.bootstrap(state:middlewares:)"
        case .presentingStateDidUpdateMethod:
            return "Beaver.Presenting.presentingStateDidUpdateMethod"
        case .unknown(let name):
            return name
        }
    }
}

extension SwiftTypeName: Hashable {
    static func ==(lhs: SwiftTypeName, rhs: SwiftTypeName) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return name.hashValue
    }
}

// MARK: - Pattern matching

private func ~= (pattern: String, value: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
        fatalError("Could not build regex with pattern: \(pattern)")
    }
    let range = NSMakeRange(0, value.characters.count)
    return regex.matches(in: value, options: .anchored, range: range).count > 0
}
