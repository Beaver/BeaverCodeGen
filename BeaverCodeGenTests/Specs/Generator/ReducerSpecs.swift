import Quick
import Nimble

@testable import BeaverCodeGen

final class ReducerSpecs: QuickSpec {
    override func spec() {
        describe("Reducer") {
            describe("description") {
                it("should return a string containing the Reducer's code") {
                    let code = Reducer(moduleName: "Module").description

                    self.printDiff(code: code, expected: self.expectedCode(.reducer))

                    expect(code) == self.expectedCode(.reducer)
                }
            }
        }
    }
}
