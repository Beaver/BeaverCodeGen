import SourceKittenFramework

struct ModuleAction: Generating {
    let objectType: ObjectType = .action
    var moduleName: String
}

extension ModuleAction {
    var name: String {
        return moduleName
    }

    var description: String {
        return """
        import Beaver
        
        public protocol \(moduleName.typeName)Action: Beaver.Action {
        }
        
        public enum \(moduleName.typeName)RoutingAction: \(moduleName.typeName)Action {
            case start
            case stop
        }
        
        enum \(moduleName.typeName)UIAction: \(moduleName.typeName)Action {
            case finish
        }
        
        """
    }
    
    func addUIAction(name: String, in fileHandler: FileHandling) {
        let structure = Structure(file:fileHandler.sourceKittenFile(atPath: path))
        print(structure)

        let swiftFile: SwiftFile
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: structure.dictionary)
            swiftFile = try JSONDecoder().decode(SwiftFile.self, from: jsonData)
        } catch {
            fatalError("\(error)")
        }
        print(swiftFile)
//        swiftFile.substructure.filter { $0.name == "\()" }
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

