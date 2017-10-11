enum SwiftKind {
    case `enum`
    case enumcase
    case enumelement
    case typeref
    case `protocol`
    case unknown(value: String)
}

extension SwiftKind: Decodable {
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        switch value {
        case "source.lang.swift.decl.enum":
            self = .`enum`
        case "source.lang.swift.decl.enumcase":
            self = .enumcase
        case "source.lang.swift.decl.enumelement":
            self = .enumelement
        case "source.lang.swift.decl.typeref", "source.lang.swift.structure.elem.typeref":
            self = .typeref
        case "source.lang.swift.decl.protocol":
            self = .`protocol`
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
