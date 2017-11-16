import Quick
import Nimble

@testable import BeaverCodeGen

final class AppDelegateSpecs: QuickSpec {
    override func spec() {
        describe("AppDelegate") {
            describe("description") {
                it("should return a string containing the AppDelegate code") {
                    let code = AppDelegate().description
                    
                    self.printDiff(code: code, expected: self.expectedCode(AppType.appDelegate))
                    
                    expect(code) == self.expectedCode(AppType.appDelegate)
                }
            }
        }
    }
}
