public enum Command {
    case module(name: String)
}

public func generate(command: Command) -> String {
    switch command {
    case .module(let name):
        return Action(name: name + "Action").description
    }
}
