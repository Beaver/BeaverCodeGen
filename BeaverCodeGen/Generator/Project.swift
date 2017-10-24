public struct ProjectGenetator: Generating {
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
}

extension ProjectGenetator: CustomStringConvertible {
    public var description: String {
        return generators.map { "//\($0.path)\n\n\($0.description)" }.joined(separator: .br)
    }
}

private extension ProjectGenetator {
    var appGenerators: [Generating] {
        return [
            AppAction(),
            AppState(moduleNames: moduleNames),
            AppReducer(moduleNames: moduleNames),
            AppPresenter(moduleNames: moduleNames),
            AppDelegate()
        ]
    }
    
    func modulesGenerators(_ moduleNames: [String]) -> [Generating] {
        return moduleNames.reduce([Generating]()) { generators, moduleName in
            return generators + [
                ModuleAction(moduleName: moduleName),
                ModuleState(moduleName: moduleName),
                ModuleReducer(moduleName: moduleName),
                ViewController(moduleName: moduleName),
                ModulePresenter(moduleName: moduleName)
            ]
        }
    }
    
    var generators: [Generating] {
        return appGenerators + modulesGenerators(moduleNames)
    }
}

