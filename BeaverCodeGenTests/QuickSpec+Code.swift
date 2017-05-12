import FileKit
import Quick

extension QuickSpec {
    enum ExpectedType: String {
        case action = "Action"
        case state = "State"
        case route = "Route"
        case reducer = "Reducer"
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

