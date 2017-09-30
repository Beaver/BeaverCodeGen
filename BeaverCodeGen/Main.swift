public struct ProjectGenetator {
    private let fileHandler: FileHandling

    let path: String
    let name: String
    private(set) var moduleNames: [String]
    
    public init(path: String,
                name: String,
                moduleNames: [String] = [],
                fileHandler: FileHandling = FileHandler()) {
        self.fileHandler = fileHandler
        self.path = path
        self.name = name
        self.moduleNames = moduleNames
    }
    
    mutating public func generateProject(moduleNames: [String] = []) {
        self.moduleNames = moduleNames
        
        let state = AppState(moduleNames: moduleNames)
        
        fileHandler.writeFile(atPath: "\(path)/\(name)/AppState", content: state.description)
    }
}

