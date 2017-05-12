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

        describe("AppRoute") {
            describe("description") {
                it("should return a string containing the AppRoute's code") {
                    let code = BeaverCodeGen.AppRoute(moduleNames: ["Expected"]).description

                    self.printDiff(code: code, expected: self.appCode(.route))

                    expect(code) == self.appCode(.route)
                }
            }
        }
    }
}
