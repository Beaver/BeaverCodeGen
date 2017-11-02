enum SwiftKind {
    case `enum`
    case enumcase
    case enumelement
    case typeref
    case `protocol`
    case `struct`
    case `var`
    case method
    case `extension`
    case staticMethod
    case `switch`
    case call
    case `class`
    case argument
    case unknown(value: String)
}

extension SwiftKind: Decodable {
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "source.lang.swift.decl.enum":
            self = .`enum`
        case "source.lang.swift.decl.enumcase", "source.lang.swift.stmt.case":
            self = .enumcase
        case "source.lang.swift.decl.enumelement":
            self = .enumelement
        case "source.lang.swift.decl.typeref", "source.lang.swift.structure.elem.typeref":
            self = .typeref
        case "source.lang.swift.decl.protocol":
            self = .`protocol`
        case "source.lang.swift.decl.struct":
            self = .`struct`
        case "source.lang.swift.decl.var.instance":
            self = .`var`
        case "source.lang.swift.decl.function.method.instance":
            self = .method
        case "source.lang.swift.decl.function.method.static":
            self = .staticMethod
        case "source.lang.swift.decl.extension":
            self = .`extension`
        case "source.lang.swift.stmt.switch":
            self = .`switch`
        case "source.lang.swift.expr.call":
            self = .call
        case "source.lang.swift.decl.class":
            self = .`class`
        case "source.lang.swift.expr.argument":
            self = .argument
        default:
            self = .unknown(value: value)
        }
    }
}

extension SwiftKind {
    var name: String {
        switch self {
        case .`enum`:
            return "enum"
        case .enumcase:
            return "enumcase"
        case .enumelement:
            return "enumelement"
        case .typeref:
            return "typeref"
        case .`protocol`:
            return "protocol"
        case .`struct`:
            return "struct"
        case .`var`:
            return "var"
        case .method:
            return "method"
        case .staticMethod:
            return "method.static"
        case .`extension`:
            return "extension"
        case .`switch`:
            return "switch"
        case .call:
            return "call"
        case .`class`:
            return "class"
        case .argument:
            return "argument"
        case .unknown(let value):
            return value
        }
    }
}

extension SwiftKind: Equatable {
    static func ==(lhs: SwiftKind, rhs: SwiftKind) -> Bool {
        return lhs.name == rhs.name
    }
}
