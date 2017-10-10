import SourceKittenFramework

public protocol FileHandling {
    var basePath: String { get }
    
    func readFile(atPath path: String) -> String
    func writeFile(atPath path: String, content: Data)
    
    func sourceKittenFile(atPath path: String) -> File
}

extension FileHandling {
    public func writeFile(atPath path: String, content: String) {
        guard let data = content.data(using: .utf8) else {
            fatalError("Couldn't convert content to UTF8 data")
        }
        
        writeFile(atPath: path, content: data)
    }
}

public struct FileHandler: FileHandling {
    private let fileManager = FileManager()

    public let basePath: String
    
    public init(basePath: String) {
        guard basePath.characters.count > 0 else {
            fatalError("basePath can't be empty")
        }
        
        self.basePath = basePath
    }
    
    public func readFile(atPath path: String) -> String {
        guard let file = FileHandle(forReadingAtPath: "\(basePath)/\(path)") else {
            fatalError("Couldn't find resource at path: \(basePath)/\(path)")
        }
        
        let data = file.readDataToEndOfFile()
        file.closeFile()
        guard let result = String(data: data, encoding: .utf8) else {
            fatalError("Couldn't convert file content to UTF8 string")
        }
        return result
    }
    
    public func writeFile(atPath path: String, content: Data) {
        var pathComponents = path.split(separator: "/")
        guard let fileName = pathComponents.last else {
            fatalError("Path needs to contain at least one component")
        }
        pathComponents.removeLast()
        let dirPath = basePath + "/" + pathComponents.joined(separator: "/")
        
        var isDirectory = ObjCBool(false)
        if !fileManager.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try! fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        } else if !isDirectory.boolValue {
            fatalError("Couldn't create the directory (\(dirPath)) because a file with the same path already exists")
        }
        
        if !fileManager.createFile(atPath: "\(dirPath)/\(fileName)", contents: content, attributes: nil) {
            fatalError("Couldn't write file at path: \(dirPath)/\(fileName)")
        }
    }
    
    public func sourceKittenFile(atPath path: String) -> File {
        guard let file = File(path: basePath + "/" + path) else {
            fatalError("Couldn't open file at path \(basePath + "/" + path)")
        }
        return file
    }
}

