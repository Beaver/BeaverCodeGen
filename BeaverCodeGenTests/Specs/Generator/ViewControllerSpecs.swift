import Quick
import Nimble

@testable import BeaverCodeGen

final class ViewControllerSpecs: QuickSpec {
    override func spec() {
        describe("ViewController") {
            describe("description") {
                it("should return a string containing the ViewController's code") {
                    let code = ViewController(moduleName: "ModuleOne").description

                    self.printDiff(code: code, expected: self.expectedCode(ModuleOneType.viewController))

                    expect(code) == self.expectedCode(ModuleOneType.viewController)
                }
            }
        }
    }
}
