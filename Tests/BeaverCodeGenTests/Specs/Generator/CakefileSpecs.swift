import Quick
import Nimble

@testable import BeaverCodeGen

final class CakefileSpecs: QuickSpec {
    override func spec() {
        describe("RootCakefile") {
            describe("description") {
                it("should return a string containing the Cakefile code") {
                    let code = RootCakefile().description
                    
                    self.printDiff(code: code, expected: self.expectedCode(ConfigType.cakefile))
                    
                    expect(code) == self.expectedCode(ConfigType.cakefile)
                }
            }
        }
        
        describe("TargetCakefile") {
            describe("description") {
                it("should return a string containing the Cakefile code") {
                    let code = TargetCakefile(targetName: "ModuleOne").description
                    
                    self.printDiff(code: code, expected: self.expectedCode(ConfigType.targetCakefile))
                    
                    expect(code) == self.expectedCode(ConfigType.targetCakefile)
                }
            }
        }
    }
}
