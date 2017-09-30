public enum Command {
    case module(name: String)
}

public func generate(command: Command) -> String {
    switch command {
    case .module(let name):
        
        fatalError("toto")
        
        return ModuleAction(moduleName: name + "Action").description
    }
}
