import Quick
import Nimble

@testable import BeaverCodeGen

final class StateSpecs: QuickSpec {
    override func spec() {
        describe("State") {
            describe("ModuleState") {
                it("should return a string containing the State's code") {
                    let code = BeaverCodeGen.ModuleState(moduleName: "ModuleOne").description
                    
                    self.printDiff(code: code, expected: self.expectedCode(CoreType.moduleOneState))
                    
                    expect(code) == self.expectedCode(CoreType.moduleOneState)
                }
            }
            
            describe("AppState") {
                it("should return a string containing the State's code") {
                    let code = BeaverCodeGen.AppState(moduleNames: ["ModuleOne", "ModuleTwo"]).description
                    
                    self.printDiff(code: code, expected: self.expectedCode(CoreType.appState))
                    
                    expect(code) == self.expectedCode(CoreType.appState)
                }
            }
        }
    }
}
