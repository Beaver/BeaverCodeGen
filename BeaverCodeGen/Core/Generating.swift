public protocol Generating: CustomStringConvertible {
    var path: String { get }
    
    func generate(in fileHandler: FileHandling)
    func byInserting(module moduleName: String, in fileHanlder: FileHandling) -> Self
}

extension Generating {
    public func generate(in fileHandler: FileHandling) {
        fileHandler.writeFile(atPath: path, content: description)
    }

    public func byInserting(module moduleName: String, in fileHanlder: FileHandling) -> Self {
        return self
    }
}

public protocol SwiftGenerating: Generating {
    var framework: String { get }
    var name: String { get }
    var objectType: ObjectType { get }
    var isTestClass: Bool { get }
    var isModule: Bool { get }
}

extension SwiftGenerating {
    public var path: String {
        let nameSuffix = isTestClass ? "Tests" : ""
        let basePath = isModule ? "Module/\(framework)/" : ""
        return "\(basePath)\(framework)\(nameSuffix)/\(name)\(objectType.rawValue)\(nameSuffix).swift"
    }
    
    public var framework: String {
        return name
    }
    
    public var isTestClass: Bool {
        return false
    }
    
    public var isModule: Bool {
        return name != "App"
    }
}
