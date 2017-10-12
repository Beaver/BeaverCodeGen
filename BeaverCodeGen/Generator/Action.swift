struct ModuleAction: Generating {
    let objectType: ObjectType = .action
    var moduleName: String

    var actions: [ActionType]
    let defaultActions: [ActionType] = [.routing(EnumCase(name: "Start")),
                                        .routing(EnumCase(name: "Stop")),
                                        .ui(EnumCase(name: "Finish"))]
    
    init(moduleName: String,
         actions: [ActionType] = []) {
        self.moduleName = moduleName
        self.actions = actions
    }
}

// MARK: - Generation methods

extension ModuleAction {
    var name: String {
        return moduleName
    }
    
    var uiActions: [ActionType] {
        return defaultActions.filter { $0.isUI } + actions.filter { $0.isUI }
    }
    
    var routingActions: [ActionType] {
        return defaultActions.filter { $0.isRouting } + actions.filter { $0.isRouting }
    }

    var description: String {
        return """
        import Beaver
        
        public protocol \(moduleName.typeName)Action: Beaver.Action {
        }
        
        public enum \(moduleName.typeName)RoutingAction: \(moduleName.typeName)Action {
        \(routingActions.map { $0.description }.joined(separator: .br).indented)
        }
        
        enum \(moduleName.typeName)UIAction: \(moduleName.typeName)Action {
        \(uiActions.map { $0.description }.joined(separator: .br).indented)
        }
        
        """
    }
    
    func insert(action: ActionType, in fileHandler: FileHandling) {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)

        guard let actionEnum = swiftFile.find(byType: action.toSwiftType(moduleName: moduleName),
                                          withInheritedType: [.moduleAction(moduleName: moduleName)],
                                          recursive: true).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find \(moduleName)UIAction in \(fileHandler)")
        }
        
        let lastEnumcase = actionEnum.find(byKind: .enumcase).last
        let offset = lastEnumcase?.offset ?? actionEnum.offset

        fileHandler.insert(content: action.description.br.indented,
                           atOffset: offset,
                           atNextLine: true,
                           inFileAtPath: path)
    }
}

// MARK: - ActionType

extension ModuleAction {
    enum ActionType: CustomStringConvertible {
        case ui(EnumCase)
        case routing(EnumCase)
        
        var name: String {
            switch self {
            case .ui(let enumCase):
                return enumCase.name
            case .routing(let enumCase):
                return enumCase.name
            }
        }
        
        var isUI: Bool {
            switch self {
            case .ui:
                return true
            case .routing:
                return false
            }
        }
        
        var isRouting: Bool {
            switch self {
            case .ui:
                return false
            case .routing:
                return true
            }
        }
        
        func toSwiftType(moduleName: String) -> SwiftType {
            switch self {
            case .ui:
                return .moduleUIAction(moduleName: moduleName)
            case .routing:
                return .moduleRoutingAction(moduleName: moduleName)
            }
        }
        
        var description: String {
            switch self {
            case .ui(let enumCase):
                return enumCase.description
            case .routing(let enumCase):
                return enumCase.description
            }
        }
    }
}

// MARK: - App Action

struct AppAction: Generating {
    let objectType: ObjectType = .action
    let name = "App"
    
    var actions: [EnumCase]
    let defaultActions = [EnumCase(name: "start", arguments: [EnumCase.Argument(name: "module", type: "Action")]),
                          EnumCase(name: "stop", arguments: [EnumCase.Argument(name: "module", type: "Action")])]
    
    init(actions: [EnumCase] = []) {
        self.actions = actions
    }
}

// MARK: - Generation methods

extension AppAction {
    var allActions: [EnumCase] {
        return defaultActions + actions
    }
    
    var description: String {
        return """
        import Beaver
        
        enum AppAction: Beaver.Action {
        \(allActions.map { $0.description }.joined(separator: .br).indented)
        }
        
        """
    }
    
    func insert(action: EnumCase, in fileHandler: FileHandling) {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)

        guard let actionEnum = swiftFile.find(byType: .appAction,
                                              withInheritedType: [.beaverAction],
                                              recursive: true).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find AppAction in \(fileHandler)")
        }

        let lastEnumcase = actionEnum.find(byKind: .enumcase).last
        let offset = lastEnumcase?.offset ?? actionEnum.offset

        fileHandler.insert(content: action.description.br.indented,
                           atOffset: offset,
                           atNextLine: true,
                           inFileAtPath: path)
    }
}

