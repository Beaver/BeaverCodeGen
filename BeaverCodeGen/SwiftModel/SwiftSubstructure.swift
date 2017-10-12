// MARK: - Substructure

struct SwiftSubstructure {
    let type: SwiftType?
    let kind: SwiftKind

    let inheritedType: Set<SwiftType>
    
    let length: Int
    let bodyLength: Int?
    let nameLength: Int
    
    let offset: Int
    let nameOffset: Int
    let bodyOffset: Int?

    var elements: [SwiftElement]
    let substructure: [SwiftSubstructure]
}

extension SwiftSubstructure: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(SwiftType.self, forKey: .name)
        kind = try values.decode(SwiftKind.self, forKey: .kind)
        inheritedType = Set(try values.decodeIfPresent([SwiftType].self, forKey: .inheritedType) ?? [])
        length = try values.decode(Int.self, forKey: .length)
        bodyLength = try values.decodeIfPresent(Int.self, forKey: .bodyLength)
        nameLength = try values.decode(Int.self, forKey: .nameLength)
        offset = try values.decode(Int.self, forKey: .offset)
        nameOffset = try values.decode(Int.self, forKey: .nameOffset)
        bodyOffset = try values.decodeIfPresent(Int.self, forKey: .bodyOffset)
        elements = try values.decodeIfPresent([SwiftElement].self, forKey: .elements) ?? []
        substructure = try values.decodeIfPresent([SwiftSubstructure].self, forKey: .substructure) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "key.name"
        
        case kind = "key.kind"
        case inheritedType = "key.inheritedtypes"
        
        case length = "key.length"
        case bodyLength = "key.bodylength"
        case nameLength = "key.namelength"
        
        case offset = "key.offset"
        case nameOffset = "key.nameoffset"
        case bodyOffset = "key.bodyoffset"
        
        case elements = "key.elements"
        case substructure = "key.substructure"
    }
}

// MARK: - Type

enum SwiftType {
    case beaverAction
    case moduleAction(moduleName: String)
    case moduleUIAction(moduleName: String)
    case moduleRoutingAction(moduleName: String)
    case appAction
    case beaverState
    case appState
    case moduleState(moduleName: String)
    case unknown(name: String)
}

extension SwiftType: Decodable {
    init(from decoder: Decoder) throws {
        let name: String = try {
            if let values = try? decoder.container(keyedBy: CodingKeys.self) {
                return try values.decode(String.self, forKey: .name)
            } else {
                return try decoder.singleValueContainer().decode(String.self)
            }
        }()
        switch name {
        case "^(Beaver\\.)?Action$":
            self = .beaverAction
        case ".*UIAction$":
            self = .moduleUIAction(moduleName: name.replacingOccurrences(of: "UIAction", with: ""))
        case ".*RoutingAction$":
            self = .moduleRoutingAction(moduleName: name.replacingOccurrences(of: "RoutingAction", with: ""))
        case "^AppAction$":
            self = .appAction
        case ".*Action$":
            self = .moduleAction(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"Action".characters.count)]))
        case "^(Beaver\\.)?State$":
            self = .beaverState
        case "^AppState$":
            self = .appState
        case ".*State$":
            self = .moduleState(moduleName: String(name[..<name.index(name.endIndex, offsetBy: -"State".characters.count)]))
        default:
            self = .unknown(name: name)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "key.name"
    }
}

extension SwiftType {
    var isModuleState: Bool {
        switch self {
        case .moduleState:
            return true
        default:
            return false
        }
    }
    
    var name: String {
        switch self {
        case .beaverAction:
            return "Beaver.Action"
        case .moduleAction(let moduleName):
            return "\(moduleName)Action"
        case .moduleUIAction(let moduleName):
            return "\(moduleName)UIAction"
        case .moduleRoutingAction(let moduleName):
            return "\(moduleName)RoutingAction"
        case .appAction:
            return "AppAction"
        case .beaverState:
            return "Beaver.State"
        case .appState:
            return "AppState"
        case .moduleState(let moduleName):
            return "\(moduleName)State"
        case .unknown(let name):
            return name
        }
    }
}

extension SwiftType: Hashable {
    static func ==(lhs: SwiftType, rhs: SwiftType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return name.hashValue
    }
}

// MARK: - Pattern matching

private func ~= (pattern: String, value: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
        fatalError("Could not build regex with pattern: \(pattern)")
    }
    let range = NSMakeRange(0, value.characters.count)
    return regex.matches(in: value, options: .anchored, range: range).count > 0
}
