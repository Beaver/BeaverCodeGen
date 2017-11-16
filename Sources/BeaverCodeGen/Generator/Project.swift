public struct ProjectGenetator: SwiftGenerating {
    public let objectType: ObjectType = .project
    
    public let name: String
    let moduleNames: [String]
    
    public init(name: String,
                moduleNames: [String] = []) {
        self.name = name
        self.moduleNames = moduleNames
    }
    
    public func generate(in fileHandler: FileHandling) {
        generators.forEach {
            $0.generate(in: fileHandler)
        }
    }
    
    public func byInserting(module moduleName: String, in filehandler: FileHandling) -> ProjectGenetator {
        modulesGenerators([moduleName]).forEach {
            $0.generate(in: filehandler)
        }

        appGenerators.forEach {
            _ = $0.byInserting(module: moduleName, in: filehandler)
        }
        
        return ProjectGenetator(name: name, moduleNames: moduleNames + [moduleName])
    }
    
    public func byInserting<ActionType: ModuleActionGenerating & ActionInserting>(action: EnumCase,
                                                                                  ofType type: ActionType.Type,
                                                                                  toModule moduleName: String,
                                                                                  in fileHandler: FileHandling) -> ProjectGenetator {
        let moduleAction = ActionType(moduleName: moduleName, actions: [])
        _ = moduleAction.byInserting(action: action, in: fileHandler)
        return self
    }
}

extension ProjectGenetator: CustomStringConvertible {
    public var description: String {
        return generators.map { "//\($0.path)\n\n\($0.description)" }.joined(separator: .br)
    }
}

private extension ProjectGenetator {
    var appGenerators: [Generating] {
        return [
            CoreAppAction(),
            AppState(moduleNames: moduleNames),
            AppReducer(moduleNames: moduleNames),
            AppPresenter(moduleNames: moduleNames),
            AppDelegate(),
            RootCakefile(),
            RootPodfile(),
            RootGitIgnore(),
            AppInfoPList(isTest: false),
            AppInfoPList(isTest: true)
        ]
    }
    
    func modulesGenerators(_ moduleNames: [String]) -> [Generating] {
        return moduleNames.reduce([SwiftGenerating]()) { generators, moduleName in
            return generators + [
                ModuleUIAction(moduleName: moduleName),
                ModuleRoutingAction(moduleName: moduleName),
                ModuleState(moduleName: moduleName),
                ModuleReducer(moduleName: moduleName),
                ViewController(moduleName: moduleName),
                ModulePresenter(moduleName: moduleName),
                TargetCakefile(targetName: moduleName),
                TargetPodfile(targetName: moduleName),
                ModuleInfoPList(moduleName: moduleName, isTest: false),
                ModuleInfoPList(moduleName: moduleName, isTest: true)
            ]
        }
    }
    
    var coreGenerators: [Generating] {
        return [
            TargetCakefile(targetName: "Core"),
            TargetPodfile(targetName: "Core"),
            ModuleInfoPList(moduleName: "Core", isTest: false),
            ModuleInfoPList(moduleName: "Core", isTest: true)
        ]
    }
    
    var generators: [Generating] {
        return appGenerators + modulesGenerators(moduleNames) + coreGenerators
    }
}

