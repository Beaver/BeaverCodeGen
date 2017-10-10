import SourceKittenFramework

@testable import BeaverCodeGen

final class FileHandlerMock: FileHandling {
    var basePath: String = "fake_path"
    
    var contents = [String:String]()
    var paths = [String:Int]()

    private(set) var readFileCallCount = 0
    private(set) var writeFileCallCount = 0
    
    init() {
    }
    
    func readFile(atPath path: String) -> String {
        paths[path, default: 0] += 1
        readFileCallCount += 1
        return contents[path]!
    }
    
    func writeFile(atPath path: String, content: Data) {
        paths[path, default: 0] += 1
        contents[path] = String(data: content, encoding: .utf8)
    }
    
    func sourceKittenFile(atPath path: String) -> File {
        paths[path, default: 0] += 1
        
        guard let content = contents[path] else {
            fatalError("Content not set for path \(path)")
        }
        
        return File(contents: content)
    }
}
