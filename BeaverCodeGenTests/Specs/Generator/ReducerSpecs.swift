import Quick
import Nimble

@testable import BeaverCodeGen

final class ReducerSpecs: QuickSpec {
    override func spec() {
        describe("Reducer") {
            describe("ModuleReducer") {
                describe("description") {
                    it("should return a string containing the Reducer's code") {
                        let code = ModuleReducer(moduleName: "ModuleOne").description

                        self.printDiff(code: code, expected: self.expectedCode(ModuleOneType.reducer))

                        expect(code) == self.expectedCode(ModuleOneType.reducer)
                    }
                }
            }
            
            describe("AppReducer") {
                describe("description") {
                    it("should return a string containing the Reducer's code") {
                        let code = BeaverCodeGen.AppReducer(moduleNames: ["ModuleOne", "ModuleTwo"]).description
                        
                        self.printDiff(code: code, expected: self.expectedCode(AppType.reducer))
                        
                        expect(code) == self.expectedCode(AppType.reducer)
                    }
                }
            }
        }
    }
}
