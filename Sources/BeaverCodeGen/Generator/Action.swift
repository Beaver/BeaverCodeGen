// MARK: - ActionGenerating

public protocol ModuleActionGenerating: SwiftGenerating {
    init(moduleName: String, actions: [EnumCase])
}

// MARK: - ActionInserting

public protocol ActionInserting: PathRepresentable {
    func isMatchingActionToInsert(_ index: SwiftIndexable) -> Bool
    func copy(byAddingAction action: EnumCase) -> Self
}

extension ActionInserting {
    func byInserting(action: EnumCase, in fileHandler: FileHandling) -> Self {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)
        
        guard let actionEnum = swiftFile.find(recursive: true, isMatching: {
            isMatchingActionToInsert($0)
        }).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find AppAction in \(fileHandler) at path \(path)")
        }
        
        let lastEnumcase = actionEnum.find { $0.kind == .enumcase }.last
        let offset = lastEnumcase?.offset ?? actionEnum.offset
        
        _ = fileHandler.insert(content: action.description.br.indented,
                               atOffset: offset,
                               withSelector: .matching(string: .br, insert: .after),
                               inFileAtPath: path)
        
        return copy(byAddingAction: action)
    }
}

// MARK: - ModuleUIAction

public struct ModuleUIAction: ModuleActionGenerating {
    public let objectType: ObjectType = .action
    var moduleName: String

    var actions: [EnumCase]
    let defaultActions: [EnumCase] = [EnumCase(name: "Finish")]
    
    public init(moduleName: String,
                actions: [EnumCase] = []) {
        self.moduleName = moduleName
        self.actions = actions
    }
}

// MARK: - Generation methods

extension ModuleUIAction {
    public var name: String {
        return moduleName
    }
    
    var allActions: [EnumCase] {
        return defaultActions + actions
    }
    
    public var description: String {
        return """
        import Beaver
        import Core
        
        enum \(moduleName.typeName)UIAction: \(moduleName.typeName)Action {
        \(allActions.map { $0.description }.joined(separator: .br).indented)
        }
        
        """
    }
}

// MARK: - ActionInserting

extension ModuleUIAction: ActionInserting {
    public func copy(byAddingAction action: EnumCase) -> ModuleUIAction {
        return ModuleUIAction(moduleName: moduleName, actions: actions + [action])
    }
    
    public func isMatchingActionToInsert(_ index: SwiftIndexable) -> Bool {
        return index.typeName == .moduleUIAction(moduleName: self.moduleName) && index.doesInherit(from: [.moduleAction(moduleName: moduleName)])
    }
}

// MARK: - Module Routing Action

public struct ModuleRoutingAction: ModuleActionGenerating {
    public let objectType: ObjectType = .action
    public let framework = "Core"
    public let moduleName: String
    
    var actions: [EnumCase]
    let defaultActions: [EnumCase] = [EnumCase(name: "Start"),
                                      EnumCase(name: "Stop")]
    
    public init(moduleName: String,
                actions: [EnumCase] = []) {
        self.moduleName = moduleName
        self.actions = actions
    }
}

// MARK: - Generation methods

extension ModuleRoutingAction {
    public var name: String {
        return moduleName
    }
    
    var allActions: [EnumCase] {
        return defaultActions + actions
    }
    
    public var description: String {
        return """
        import Beaver
        
        public protocol \(moduleName.typeName)Action: Beaver.Action {
        }
        
        public enum \(moduleName.typeName)RoutingAction: \(moduleName.typeName)Action {
        \(allActions.map { $0.description }.joined(separator: .br).indented)
        }
        
        """
    }
}

// MARK: - ActionInserting

extension ModuleRoutingAction: ActionInserting {
    public func copy(byAddingAction action: EnumCase) -> ModuleRoutingAction {
        return ModuleRoutingAction(moduleName: moduleName, actions: actions + [action])
    }
    
    public func isMatchingActionToInsert(_ index: SwiftIndexable) -> Bool {
        return index.typeName == .moduleRoutingAction(moduleName: self.moduleName) && index.doesInherit(from: [.moduleAction(moduleName: moduleName)])
    }
}

// MARK: - Core App Action

struct CoreAppAction: SwiftGenerating {
    let objectType: ObjectType = .action
    let name = "App"
    let framework = "Core"
    let isModule = true
    
    var actions: [EnumCase]
    let defaultActions = [EnumCase(name: "start", arguments: [EnumCase.Argument(name: "module", type: "Action")]),
                          EnumCase(name: "stop", arguments: [EnumCase.Argument(name: "module", type: "Action")])]
    
    init(actions: [EnumCase] = []) {
        self.actions = actions
    }
}

// MARK: - Generation methods

extension CoreAppAction {
    var allActions: [EnumCase] {
        return defaultActions + actions
    }
    
    var description: String {
        return """
        import Beaver
        
        public enum AppAction: Beaver.Action {
        \(allActions.map { $0.description }.joined(separator: .br).indented)
        }
        
        """
    }
}

// MARK: - ActionInserting

extension CoreAppAction: ActionInserting {
    func copy(byAddingAction action: EnumCase) -> CoreAppAction {
        return CoreAppAction(actions: actions + [action])
    }
    
    func isMatchingActionToInsert(_ index: SwiftIndexable) -> Bool {
        return index.typeName == .appAction && index.doesInherit(from: [.beaverAction])
    }
}


