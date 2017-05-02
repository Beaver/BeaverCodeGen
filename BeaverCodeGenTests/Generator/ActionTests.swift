import XCTest

@testable import BeaverCodeGen

final class MainTests: XCTestCase {
    func test_generate_module_should_return_a_module_code() {
        let code = generate(command: .module(name: "Test"))

        let expectedCode = "enum TestAction {\n" +
                "    open // Opens the main controller of the module\n" +
                "}\n"

        XCTAssertEqual(code, expectedCode)
    }
}
