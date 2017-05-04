import Quick
import Nimble

@testable import BeaverCodeGen

final class ActionSpecs: QuickSpec {
    override func spec() {
        describe("Action") {
            describe("description") {
                it("should return a string containing the action's code") {
                    let code = generate(command: .module(name: "Test"))

                    expect(code) == "enum TestAction {\n" +
                            "    open // Opens the main controller of the module\n" +
                            "}\n"
                }
            }
        }
    }
}
