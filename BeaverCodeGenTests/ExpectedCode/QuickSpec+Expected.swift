import FileKit
import Quick

extension QuickSpec {
    var expectedActionCode: String {
        return try! TextFile(path: dirPath + "ExpectedAction".swift).read()
    }

    var expectedStateCode: String {
        return try! TextFile(path: dirPath + "ExpectedState".swift).read()
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

fileprivate extension String {
    var swift: String {
        return self + ".swift"
    }
}
