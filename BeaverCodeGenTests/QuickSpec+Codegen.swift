import Quick
import Diff

@testable import BeaverCodeGen

protocol FilePathRepresentable {
    var filePath: String { get }
}

extension QuickSpec {
    enum CoreType: String, FilePathRepresentable {
        case moduleOneState = "ModuleOneState"
        case appState = "AppState"
        
        var filePath: String {
            return "GeneratedCode/Core/\(rawValue).swift"
        }
    }
    
    enum ModuleOneType: String, FilePathRepresentable {
        case action = "Action"
        case reducer = "Reducer"
        case presenter = "Presenter"
        case viewController = "ViewController"

        var filePath: String {
            return "GeneratedCode/ModuleOne/ModuleOne\(rawValue).swift"
        }
    }

    enum AppType: String, FilePathRepresentable {
        case route = "Route"
        case presenter = "Presenter"
        case action = "Action"
        case appDelegate = "Delegate"
        case reducer = "Reducer"
        
        var filePath: String {
            return "GeneratedCode/App/App\(rawValue).swift"
        }
    }
    
    enum ConfigType: String, FilePathRepresentable {
        case cakefile = "Cakefile"
        case targetCakefile = "ModuleOne/Cakefile.rb"
        
        var filePath: String {
            return "GeneratedCode/\(rawValue)"
        }
    }

    func expectedCode(_ type: FilePathRepresentable) -> String {
        return readFile(inDirectory: dirPath, atPath: type.filePath)
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

private extension QuickSpec {
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
        return str[lineRange].replacingOccurrences(of: "\n", with: "\\n")
    }

    func diffIndicator(ofChar at: Int, in str: String) -> String {
        if str.characters.count <= at {
            return ""
        }
        let index = str.index(str.startIndex, offsetBy: at)
        let lineRange = str.lineRange(for: Range(uncheckedBounds: (index, str.index(after: index))))
        return String(repeating: " ", count: at - str.distance(from: str.startIndex, to: lineRange.lowerBound)) + "^"
    }
    
    func readFile(inDirectory basePath: String, atPath path: String) -> String {
        return FileHandler(basePath: basePath).readFile(atPath: path)
    }
}
