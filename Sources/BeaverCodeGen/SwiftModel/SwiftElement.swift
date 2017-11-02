struct SwiftElement {
    let kind: SwiftKind
    let offset: Int
    let length: Int
}

extension SwiftElement: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decode(SwiftKind.self, forKey: .kind)
        offset = try values.decode(Int.self, forKey: .offset)
        length = try values.decode(Int.self, forKey: .length)
    }
    
    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case offset = "key.offset"
        case length = "key.length"
    }
}

