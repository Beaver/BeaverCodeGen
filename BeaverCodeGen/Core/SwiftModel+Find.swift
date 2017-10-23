protocol SwiftIndexable {
    var parent: SwiftIndexable? { get }
    
    var typeName: SwiftTypeName? { get }
    var kind: SwiftKind { get }
    var inheritedType: Set<SwiftTypeName> { get }

    var offset: Int { get }
    var bodyOffset: Int? { get }
    var bodyLength: Int? { get }
}

extension SwiftIndexable {
    var endOffset: Int? {
        switch (bodyOffset, bodyLength) {
        case (.some(let offset), .some(let length)):
            return offset + length
        default:
            return nil
        }
    }
    
    func doesInherit(from types: [SwiftTypeName]) -> Bool {
        return inheritedType.intersection(types).count == inheritedType.count
    }
}

protocol SwiftScanable {
    var indexes: [SwiftIndexable] { get }
    
    func find(recursive: Bool, isMatching: (SwiftIndexable) -> Bool) -> [SwiftIndexable]
}

extension SwiftScanable {
    var parent: SwiftIndexable? {
        return nil
    }

    func find(recursive: Bool = false, isMatching: (SwiftIndexable) -> Bool) -> [SwiftIndexable] {
        return indexes.reduce([SwiftIndexable]()) { (result, index) in
            let isIndexMatching = isMatching(index)
            let firstIndex: [SwiftIndexable] = isIndexMatching ? [index] : []
            let subIndexes = (index as? SwiftScanable)?.find(recursive: recursive, isMatching: isMatching) ?? []
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

