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
                
                describe("addAction(name:in:)") {
                    it("should rewrite the action file with one more action") {
                        var generator = BeaverCodeGen.ModuleAction(moduleName: "ModuleOne")
                        let fileHandlerMock = FileHandlerMock()
                        
                        fileHandlerMock.contents["ModuleOne/ModuleOneAction.swift"] = generator.description
                        
                        generator.insertUIAction(name: "Test", in: fileHandlerMock)
                        
                        generator.actions.append(.ui("Test"))
                        
                        expect(fileHandlerMock.contents["ModuleOne/ModuleOneAction.swift"]) == generator.description
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
