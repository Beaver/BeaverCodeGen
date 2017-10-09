@testable import BeaverCodeGen

final class FileHandlerMock: FileHandling {
    var dirPath: String = "fake_path"
    
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
}
