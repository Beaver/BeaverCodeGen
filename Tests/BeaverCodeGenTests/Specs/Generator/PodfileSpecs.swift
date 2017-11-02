import Quick
import Nimble

@testable import BeaverCodeGen

final class PodfileSpecs: QuickSpec {
    override func spec() {
        describe("RootPodfile") {
            describe("description") {
                it("should return a string containing the Podfile code") {
                    let code = RootPodfile().description
                    
                    self.printDiff(code: code, expected: self.expectedCode(ConfigType.podfile))
                    
                    expect(code) == self.expectedCode(ConfigType.podfile)
                }
            }
        }
        
        describe("TargetPodfile") {
            describe("description") {
                it("should return a string containing the Podfile code") {
                    let code = TargetPodfile(targetName: "ModuleOne").description

                    self.printDiff(code: code, expected: self.expectedCode(ConfigType.targetPodfile))

                    expect(code) == self.expectedCode(ConfigType.targetPodfile)
                }
            }
        }
    }
}
