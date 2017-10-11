struct ModuleAction: Generating {
    let objectType: ObjectType = .action
    var moduleName: String

    var actions: [ActionType]
    let defaultActions: [ActionType] = [.routing("start"), .routing("stop"), .ui("finish")]
    
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
        \(routingActions.map { "case \($0.name.varName)" }.joined(separator: .br).indented)
        }
        
        enum \(moduleName.typeName)UIAction: \(moduleName.typeName)Action {
        \(uiActions.map { "case \($0.name.varName)" }.joined(separator: .br).indented)
        }
        
        """
    }
    
    func insertUIAction(name: String, in fileHandler: FileHandling) {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)

        guard let action = swiftFile.find(byType: .moduleUIAction(moduleName: moduleName),
                                          withInheritedType: [.moduleAction(moduleName: moduleName)],
                                          recursive: true).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find \(moduleName)UIAction in \(fileHandler)")
        }
        
        let lastEnumcase = action.find(byKind: .enumcase).last
        let offset = lastEnumcase?.offset ?? action.offset

        fileHandler.insert(content: "case \(name.varName)".br.indented,
                           atOffset: offset,
                           atNextLine: true,
                           inFileAtPath: path)
    }
}

// MARK: - ActionType

extension ModuleAction {
    enum ActionType {
        case ui(String)
        case routing(String)
        
        var name: String {
            switch self {
            case .ui(let name):
                return name
            case .routing(let name):
                return name
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
    }
}

struct AppAction: Generating {
    let objectType: ObjectType = .action
    let name = "App"
}

extension AppAction {
    var description: String {
        return """
        import Beaver
        
        enum AppAction: Beaver.Action {
            case start(module: Action)
            case stop(module: Action)
        }
        
        """
    }
}

