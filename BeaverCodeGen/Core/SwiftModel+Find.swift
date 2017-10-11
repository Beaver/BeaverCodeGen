protocol SwiftIndexable {
    var type: SwiftType? { get }
    var kind: SwiftKind { get }
    var inheritedType: Set<SwiftType> { get }

    var offset: Int { get }
    var bodyOffset: Int { get }
    var bodyLength: Int? { get }
}

extension SwiftIndexable {
    var endOffset: Int {
        return bodyOffset + (bodyLength ?? 0)
    }
}

protocol SwiftScanable {
    var indexes: [SwiftIndexable] { get }
    
    func find(byType type: SwiftType?,
              byKind kind: SwiftKind?,
              withInheritedType inheritedType: [SwiftType],
              recursive: Bool) -> [SwiftIndexable]
}

extension SwiftScanable {
    func find(byType type: SwiftType? = nil,
              byKind kind: SwiftKind? = nil,
              withInheritedType inheritedType: [SwiftType] = [],
              recursive: Bool = false) -> [SwiftIndexable] {
        return indexes.reduce([SwiftIndexable]()) { (result, index) in
            let isIndexMatching = (type == nil || index.type == type)
                && (kind == nil || index.kind == kind)
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

