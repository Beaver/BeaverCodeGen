import SourceKittenFramework

public protocol FileHandling: CustomStringConvertible {
    var basePath: String { get }
    
    func readFile(atPath path: String) -> String
    func writeFile(atPath path: String, content: Data)

    func insert(content: String,
                atOffset offset: Int,
                withSelector offsetSelector: OffsetSelector?,
                inFileAtPath path: String) -> Int
    
    func sourceKittenFile(atPath path: String) -> File
}

public struct OffsetSelector {
    public enum InsertionType {
        case after
        case before
        case over
    }
    
    let matchingString: String
    let insert: InsertionType
    let reversed: Bool
    
    public init(matching matchingString: String,
                insert: InsertionType,
                reversed: Bool = false) {
        self.matchingString = reversed ? String(matchingString.reversed()) : matchingString
        self.insert = insert
        self.reversed = reversed
    }
    
    static func matching(string: String, insert: InsertionType, reversed: Bool = false) -> OffsetSelector {
        return OffsetSelector(matching: string, insert: insert, reversed: reversed)
    }
}

extension FileHandling {
    public func writeFile(atPath path: String, content: String) {
        guard let data = content.data(using: .utf8) else {
            fatalError("Couldn't convert content to UTF8 data")
        }
        
        writeFile(atPath: path, content: data)
    }
    
    public func insert(content: String,
                       atOffset offset: Int,
                       withSelector offsetSelector: OffsetSelector? = nil,
                       inFileAtPath path: String) -> Int {
        let reversed = offsetSelector?.reversed ?? false
        
        var fileContent = readFile(atPath: path)
        if reversed {
            fileContent = String(fileContent.reversed())
        }
        
        var index = fileContent.index(fileContent.startIndex,
                                      offsetBy: reversed ? fileContent.characters.count - offset : offset)
        
        if let matchingString = offsetSelector?.matchingString,
            let range = fileContent.range(of: reversed ? String(matchingString.reversed()) : matchingString,
                                          range: index..<fileContent.endIndex) {
            index = range.lowerBound
            
            switch offsetSelector?.insert {
            case .after?:
                index = fileContent.index(index, offsetBy: matchingString.characters.count)

            case .over?:
                let distance = fileContent.distance(from: fileContent.startIndex, to: index)
                let matchingStringEnd = fileContent.index(index, offsetBy: matchingString.characters.count)
                fileContent.removeSubrange(index..<matchingStringEnd)
                index = fileContent.index(fileContent.startIndex, offsetBy: distance)

            default:
                break
            }
        }
        
        fileContent.insert(contentsOf: reversed ? String(content.reversed()) : content, at: index)

        if reversed {
            fileContent = String(fileContent.reversed())
        }

        writeFile(atPath: path, content: fileContent)
        
        if let offsetSelector = offsetSelector, offsetSelector.insert == .over {
            return content.characters.count - min(offsetSelector.matchingString.characters.count, content.characters.count)
        } else {
            return content.characters.count
        }
    }
}

extension FileHandling {
    public var description: String {
        return basePath
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
            fatalError("Couldn't open file at path \(basePath)/\(path)")
        }
        return file
    }
}

