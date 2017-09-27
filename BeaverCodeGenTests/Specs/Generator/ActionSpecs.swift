import Quick
import Nimble

@testable import BeaverCodeGen

final class ActionSpecs: QuickSpec {
    override func spec() {
        describe("Action") {
            describe("ModuleAction") {
                describe("description") {
                    it("should return a string containing the action's code") {
                        let code = BeaverCodeGen.ModuleAction(moduleName: "ModuleOne").description

                        self.printDiff(code: code, expected: self.expectedCode(ModuleOneType.action))

                        expect(code) == self.expectedCode(ModuleOneType.action)
                    }
                }
            }
            
            describe("AppAction") {
                describe("description") {
                    it("should return a string containing the action's code") {
                        let code = BeaverCodeGen.AppAction().description
                        
                        self.printDiff(code: code, expected: self.expectedCode(AppType.action))
                        
                        expect(code) == self.expectedCode(AppType.action)
                    }
                }
            }
        }
    }
}
