import Quick
import Nimble

@testable import BeaverCodeGen

final class RouteSpecs: QuickSpec {
    override func spec() {
        describe("Route") {
            describe("description") {
                it("should return a string containing the Route's code") {
                    let code = Route(moduleName: "Expected").description

                    self.printDiff(code: code, expected: self.expectedCode(.route))

                    expect(code) == self.expectedCode(.route)
                }
            }
        }
    }
}
