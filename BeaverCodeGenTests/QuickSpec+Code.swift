import Quick
import Diff

extension QuickSpec {
    enum ExpectedType: String {
        case action = "Action"
        case state = "State"
        case reducer = "Reducer"
        case presenter = "Presenter"
        case viewController = "ViewController"

        var expected: String {
            return "GeneratedCode/Module/Module\(rawValue).swift"
        }
    }

    enum AppType: String {
        case route = "Route"

        var app: String {
            return "GeneratedCode/App/App\(rawValue).swift"
        }
    }

    func expectedCode(_ type: ExpectedType) -> String {
        return readFile(atPath: "\(dirPath)/\(type.expected)")
    }

    func appCode(_ type: AppType) -> String {
        return readFile(atPath: "\(dirPath)/\(type.app)")
    }

    func printDiff(code: String, expected: String) {
        let diffs = expected.diff(to: code)

        var currentLine: String?
        for diff in diffs.elements {
            switch diff {
            case .insert(let at), .delete(let at):
                let thisLine = line(ofChar: at, in: code)
                if thisLine == currentLine {
                    break
                }
                currentLine = thisLine
                print("Expected Line >>>>>>>>")
                print("[\(line(ofChar: at, in: expected))]")
                print("------- Generated Line")
                print("[\(thisLine)]")
                print(" \(diffIndicator(ofChar: at, in: code)) ")
                print("<<<<<<<<<<<<<<<<<<<<<<")
            }
        }

        if diffs.elements.count > 0 {
            print("Expected Code >>>>>>>>")
            print(expected)
            print("------- Generated Code")
            print(code)
            print("<<<<<<<<<<<<<<<<<<<<<<")
        }
    }
}

fileprivate extension QuickSpec {
    var dirPath: String {
        var pathComponents = (#file).split(separator: "/")
        pathComponents.removeLast()
        return "/" + pathComponents.joined(separator: "/")
    }

    func line(ofChar at: Int, in str: String) -> String {
        if str.characters.count <= at {
            return ""
        }
        let index = str.index(str.startIndex, offsetBy: at)
        let lineRange = str.lineRange(for: Range(uncheckedBounds: (index, str.index(after: index))))
        return str.substring(with: lineRange).replacingOccurrences(of: "\n", with: "\\n")
    }

    func diffIndicator(ofChar at: Int, in str: String) -> String {
        if str.characters.count <= at {
            return ""
        }
        let index = str.index(str.startIndex, offsetBy: at)
        let lineRange = str.lineRange(for: Range(uncheckedBounds: (index, str.index(after: index))))
        return String(repeating: " ", count: at - str.distance(from: str.startIndex, to: lineRange.lowerBound)) + "^"
    }
    
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
}

