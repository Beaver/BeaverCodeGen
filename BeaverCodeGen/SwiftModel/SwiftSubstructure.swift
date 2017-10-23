// MARK: - Substructure

struct SwiftSubstructure {
    fileprivate(set) var parent: SwiftIndexable?
    
    let name: String?
    let typeName: SwiftTypeName?
    let kind: SwiftKind

    let inheritedType: Set<SwiftTypeName>
    
    let length: Int
    let bodyLength: Int?
    let nameLength: Int
    
    let offset: Int
    let nameOffset: Int
    let bodyOffset: Int?

    var elements: [SwiftElement]
    fileprivate(set) var substructure: [SwiftSubstructure]
}

extension SwiftSubstructure: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        parent = nil

        let typeName = try values.decodeIfPresent(SwiftTypeName.self, forKey: .name)
        if case .unknown(let value)? = typeName {
            self.typeName = try values.decodeIfPresent(SwiftTypeName.self, forKey: .typeName)
            name = value
        } else {
            self.typeName = typeName
            name = try values.decodeIfPresent(String.self, forKey: .name)
        }
        
        kind = try values.decode(SwiftKind.self, forKey: .kind)
        inheritedType = Set(try values.decodeIfPresent([SwiftTypeName].self, forKey: .inheritedType) ?? [])
        length = try values.decode(Int.self, forKey: .length)
        bodyLength = try values.decodeIfPresent(Int.self, forKey: .bodyLength)
        nameLength = try values.decode(Int.self, forKey: .nameLength)
        offset = try values.decode(Int.self, forKey: .offset)
        nameOffset = try values.decode(Int.self, forKey: .nameOffset)
        bodyOffset = try values.decodeIfPresent(Int.self, forKey: .bodyOffset)
        elements = try values.decodeIfPresent([SwiftElement].self, forKey: .elements) ?? []
        substructure = (try values.decodeIfPresent([SwiftSubstructure].self, forKey: .substructure) ?? [])
        
        substructure = substructure.map { substructure in
            var mutableSubstructure = substructure
            mutableSubstructure.parent = self
            return mutableSubstructure
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "key.name"
        case typeName = "key.typename"

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
