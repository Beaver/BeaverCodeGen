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
}

extension ProjectGenetator: CustomStringConvertible {
    public var description: String {
        return generators.map { "//\($0.path)\n\n\($0.description)" }.joined(separator: "\n")
    }
}

private extension ProjectGenetator {
    var generators: [Generating] {
        let appGenerators: [Generating] = [
            AppAction(),
            AppState(moduleNames: moduleNames),
            AppReducer(moduleNames: moduleNames),
            AppPresenter(moduleNames: moduleNames),
            AppDelegate()
        ]
        
        let modulesGenerators = moduleNames.reduce([Generating]()) { generators, moduleName in
            return generators + [
                ModuleAction(moduleName: moduleName),
                ModuleState(moduleName: moduleName),
                ModuleReducer(moduleName: moduleName),
                ViewController(moduleName: moduleName),
                ModulePresenter(moduleName: moduleName)
            ]
        }
        return appGenerators + modulesGenerators
    }
}

