protocol FileHandling {
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

struct FileHandler: FileHandling {
    func readFile(atPath path: String) -> String {
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
    
    func writeFile(atPath path: String, content: Data) {
        guard let file = FileHandle(forWritingAtPath: path) else {
            fatalError("Couldn't find resource at path: \(path)")
        }

        file.write(content)
        file.closeFile()
    }
}

