import Quick
import Nimble

@testable import BeaverCodeGen

final class PresenterSpecs: QuickSpec {
    override func spec() {
        describe("Presenter") {
            describe("description") {
                it("should return a string containing the Presenter's code") {
                    let code = Presenter(moduleName: "Expected").description

                    self.printDiff(code: code, expected: self.expectedCode(.presenter))

                    expect(code) == self.expectedCode(.presenter)
                }
            }
        }
    }
}
