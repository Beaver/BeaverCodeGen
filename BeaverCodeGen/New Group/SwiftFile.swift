struct SwiftFile {
    let diagnosticStage: String
    let substructure: [SwiftSubstructure]

    let offset: Int
    let length: Int
}

extension SwiftFile: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        diagnosticStage = try values.decode(String.self, forKey: .diagnosticStage)
        substructure = try values.decode([SwiftSubstructure].self, forKey: .substructure)
        offset = try values.decode(Int.self, forKey: .offset)
        length = try values.decode(Int.self, forKey: .length)
    }
        
    enum CodingKeys: String, CodingKey {
        case diagnosticStage = "key.diagnostic_stage"
        case substructure = "key.substructure"
        case offset = "key.offset"
        case length = "key.length"
    }
}
