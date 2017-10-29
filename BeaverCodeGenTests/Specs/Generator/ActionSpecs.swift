import Quick
import Nimble

@testable import BeaverCodeGen

final class ActionSpecs: QuickSpec {
    override func spec() {
        describe("Action") {
            describe("ModuleAction") {
                var generator: BeaverCodeGen.ModuleAction!

                beforeEach {
                    generator = BeaverCodeGen.ModuleAction(moduleName: "ModuleOne")
                }

                describe("description") {
                    it("should return a string containing the action's code") {
                        let code = generator.description

                        self.printDiff(code: code, expected: self.expectedCode(ModuleOneType.action))

                        expect(code) == self.expectedCode(ModuleOneType.action)
                    }
                }
                
                describe("byInserting(action:in:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "ModuleOne/ModuleOne/ModuleOneAction.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }
                    
                    it("should rewrite the action file with one more ui action") {
                        fileHandlerMock.contents[filePath] = generator.description
                        generator = generator.byInserting(action: .ui(EnumCase(name: "Test")), in: fileHandlerMock)
                        expect(fileHandlerMock.contents[filePath]) == generator.description
                    }
                    
                    it("should rewrite the action file with one more routing action") {
                        fileHandlerMock.contents[filePath] = generator.description
                        generator = generator.byInserting(action: .routing(EnumCase(name: "Test")), in: fileHandlerMock)
                        expect(fileHandlerMock.contents[filePath]) == generator.description
                    }
                    
                    afterEach {
                        if let code = fileHandlerMock.contents[filePath] {
                            self.printDiff(code: code, expected: generator.description)
                        }
                    }
                }
            }
            
            describe("AppAction") {
                var generator: BeaverCodeGen.AppAction!

                beforeEach {
                    generator = BeaverCodeGen.AppAction()
                }
                
                describe("description") {
                    it("should return a string containing the action's code") {
                        let code = generator.description
                        
                        self.printDiff(code: code, expected: self.expectedCode(AppType.action))
                        
                        expect(code) == self.expectedCode(AppType.action)
                    }
                }
                
                describe("insert(action:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "App/App/AppAction.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }
                    
                    it("should rewrite the action file with one more routing action") {
                        fileHandlerMock.contents[filePath] = generator.description
                        generator = generator.byInserting(action: EnumCase(name: "Test"), in: fileHandlerMock)
                        expect(fileHandlerMock.contents[filePath]) == generator.description
                    }
                    
                    afterEach {
                        if let code = fileHandlerMock.contents[filePath] {
                            self.printDiff(code: code, expected: generator.description)
                        }
                    }
                }
            }
        }
    }
}
