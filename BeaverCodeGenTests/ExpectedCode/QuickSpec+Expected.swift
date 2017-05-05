import FileKit
import Quick

extension QuickSpec {
    private var dirPath: Path {
        return Path(#file).parent
    }

    var expectedActionCode: String {
        return try! TextFile(path: dirPath + "ExpectedAction.swift").read()
    }

    func printDiff(code: String, expected: String) {
        print("<<<<<<<<<<< Expected Code")
        print(expected)
        print("Generated Code >>>>>>>>>>")
        print(code)
        print("-------------------------")
    }
}