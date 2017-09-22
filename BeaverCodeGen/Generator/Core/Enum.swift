struct EnumCase {
    let name: String

    let arguments: [(name: String?, type: String)]

    init(name: String,
         arguments: [(name: String?, type: String)] = []) {
        self.name = name
        self.arguments = arguments
    }
}

extension EnumCase: CustomStringConvertible {
    var description: String {
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

struct Enum {
    let name: String

    let isPublic: Bool

    let enumCases: [EnumCase]

    let implementing: [String]

    init(name: String,
         isPublic: Bool = false,
         enumCases: [EnumCase] = [],
         implementing: [String] = []) {
        self.name = name
        self.isPublic = isPublic
        self.enumCases = enumCases
        self.implementing = implementing
    }
}

extension Enum: CustomStringConvertible {
    private var implementingDescription: String {
        if implementing.count > 0 {
            return ": " + implementing.joined(separator: ", ")
        } else {
            return ""
        }
    }

    var description: String {
        return """
        \(isPublic ? "public " : "")enum \(name.typeName)\(implementingDescription) {
        \(enumCases.map {
            $0.description
        }.joined(separator: .br).indented)
        }
        """
    }
}
