protocol SwiftIndexable {
    var type: SwiftType? { get }
    var kind: SwiftKind { get }
    var inheritedType: Set<SwiftType> { get }

    var offset: Int { get }
    var bodyOffset: Int? { get }
    var bodyLength: Int? { get }
}

protocol SwiftScanable {
    var indexes: [SwiftIndexable] { get }
    
    func find(byType type: ((SwiftType?) -> Bool)?,
              byKind kind: SwiftKind?,
              withInheritedType inheritedType: [SwiftType],
              recursive: Bool) -> [SwiftIndexable]
}

extension SwiftScanable {
    func find(byType type: ((SwiftType?) -> Bool)? = nil,
              byKind kind: SwiftKind? = nil,
              withInheritedType inheritedType: [SwiftType] = [],
              recursive: Bool = false) -> [SwiftIndexable] {
        return indexes.reduce([SwiftIndexable]()) { (result, index) in
            let isIndexMatching = (type?(index.type) ?? true)
                && (kind == nil ||  index.kind == kind)
                && index.inheritedType.intersection(inheritedType).count == inheritedType.count

            let firstIndex: [SwiftIndexable] = isIndexMatching ? [index] : []
            let subIndexes = (index as? SwiftScanable)?.find(byType: type) ?? []
            return result + firstIndex + subIndexes
        }
    }
}

// MARK: - Substructure

extension SwiftSubstructure: SwiftScanable, SwiftIndexable {
    var indexes: [SwiftIndexable] {
        return substructure
    }
}

// MARK: - File

extension SwiftFile: SwiftScanable {
    var indexes: [SwiftIndexable] {
        return substructure
    }
}

