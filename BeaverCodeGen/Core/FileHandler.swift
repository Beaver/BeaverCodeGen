public protocol FileHandling {
    func readFile(atPath path: String) -> String
    func writeFile(atPath path: String, content: Data)
}

extension FileHandling {
    func writeFile(atPath path: String, content: String) {
        guard let data = content.data(using: .utf8) else {
            fatalError("Couldn't convert content to UTF8 data")
        }
        
        writeFile(atPath: path, content: data)
    }
}

public struct FileHandler: FileHandling {
    private let fileManager = FileManager()
    
    public init() {
    }
    
    public func readFile(atPath path: String) -> String {
        guard let file = FileHandle(forReadingAtPath: path) else {
            fatalError("Couldn't find resource at path: \(path)")
        }
        
        let data = file.readDataToEndOfFile()
        file.closeFile()
        guard let result = String(data: data, encoding: .utf8) else {
            fatalError("Couldn't convert file content to UTF8 string")
        }
        return result
    }
    
    public func writeFile(atPath path: String, content: Data) {
        let dirPath = (path.first == "/" ? "/" : "") + path.split(separator: "/").dropLast().joined(separator: "/")

        var isDirectory = ObjCBool(false)
        if !fileManager.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try! fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        } else if !isDirectory.boolValue {
            fatalError("Couldn't create the directory (\(dirPath)) because a file with the same path already exists")
        }
        
        if !fileManager.createFile(atPath: path, contents: content, attributes: nil) {
            fatalError("Couldn't write file at path: \(path)")
        }
    }
}

