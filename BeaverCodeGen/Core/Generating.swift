public protocol Generating: CustomStringConvertible {
    var name: String { get }
    var objectType: ObjectType { get }

    func generate(in fileHandler: FileHandling)
}

extension Generating {
    func generate(in fileHandler: FileHandling) {
        fileHandler.writeFile(atPath: path, content: description)
    }

    var path: String {
        return "\(name)/\(name)\(objectType.rawValue).swift"
    }
}
