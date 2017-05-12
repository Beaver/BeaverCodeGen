import FileKit
import Quick
import Diff

extension QuickSpec {
    enum ExpectedType: String {
        case action = "Action"
        case state = "State"
        case route = "Route"
        case reducer = "Reducer"
        case presenter = "Presenter"
        case viewController = "ViewController"

        var expected: String {
            return "ExpectedCode/Expected\(rawValue).swift"
        }
    }

    enum AppType: String {
        case route = "Route"

        var app: String {
            return "AppCode/App\(rawValue).swift"
        }
    }

    func expectedCode(_ type: ExpectedType) -> String {
        return try! TextFile(path: dirPath / type.expected).read()
    }

    func appCode(_ type: AppType) -> String {
        return try! TextFile(path: dirPath / type.app).read()
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
    var dirPath: Path {
        return Path(#file).parent
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
}

