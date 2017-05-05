import FileKit
import Quick

extension QuickSpec {
    enum ExpectedType: String {
        case action = "Action"
        case state = "State"
        case route = "Route"

        var expected: String {
            return "Expected\(rawValue).swift"
        }
    }

    func expectedCode(_ type: ExpectedType) -> String {
        return try! TextFile(path: dirPath + type.expected).read()
    }

    func printDiff(code: String, expected: String) {
        print("<<<<<<<<<<< Expected Code")
        print(expected)
        print("Generated Code >>>>>>>>>>")
        print(code)
        print("-------------------------")
    }
}

fileprivate extension QuickSpec {
    var dirPath: Path {
        return Path(#file).parent
    }
}

