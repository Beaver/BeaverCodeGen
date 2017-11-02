public struct EnumCase {
    let name: String
    let arguments: [Argument]
    
    public init(name: String,
                arguments: [Argument] = []) {
        self.name = name
        self.arguments = arguments
    }
}

extension EnumCase {
    public struct Argument {
        let name: String?
        let type: String
        
        public init(name: String? = nil,
                    type: String) {
            self.name = name
            self.type = type
        }
    }
}

extension EnumCase: CustomStringConvertible {
    public var description: String {
        var s = ""
        
        s += "case \(name.varName)"
        if arguments.count > 0 {
            s += "("
            s += arguments.map { argument in
                if let name = argument.name {
                    return "\(name.varName): \(argument.type.typeName)"
                } else {
                    return argument.type.typeName
                }
                }.joined(separator: ", ")
            s += ")"
        }
        
        return s
    }
}
