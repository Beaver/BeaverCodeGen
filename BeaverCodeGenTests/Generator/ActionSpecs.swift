import Quick
import Nimble

@testable import BeaverCodeGen

final class ActionSpecs: QuickSpec {
    override func spec() {
        describe("Action") {
            describe("description") {
                it("should return a string containing the action's code") {
                    let code = Action(moduleName: "Expected").description

                    self.printDiff(code: code, expected: self.expectedActionCode)

                    expect(code) == self.expectedActionCode
                }
            }
        }
    }
}
