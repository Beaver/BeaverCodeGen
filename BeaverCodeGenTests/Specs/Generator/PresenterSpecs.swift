import Quick
import Nimble

@testable import BeaverCodeGen

final class PresenterSpecs: QuickSpec {
    override func spec() {
        describe("Presenter") {
            describe("ModulePresenter") {
                it("should return a string containing the Presenter's code") {
                    let code = ModulePresenter(moduleName: "ModuleOne").description

                    self.printDiff(code: code, expected: self.expectedCode(ModuleOneType.presenter))

                    expect(code) == self.expectedCode(ModuleOneType.presenter)
                }
            }
            
            describe("AppPresenter") {
                it("should return a string containing the Presenter's code") {
                    let code = BeaverCodeGen.AppPresenter(moduleNames: ["ModuleOne", "ModuleTwo"]).description
                    
                    self.printDiff(code: code, expected: self.expectedCode(AppType.presenter))
                    
                    expect(code) == self.expectedCode(AppType.presenter)
                }
            }
        }
    }
}
