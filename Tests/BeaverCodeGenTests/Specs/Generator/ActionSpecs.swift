import Quick
import Nimble

@testable import BeaverCodeGen

final class ActionSpecs: QuickSpec {
    override func spec() {
        describe("Action") {
            describe("ModuleRoutingAction") {
                var generator: ModuleRoutingAction!

                beforeEach {
                    generator = ModuleRoutingAction(moduleName: "ModuleOne")
                }

                describe("description") {
                    it("should return a string containing the action's code") {
                        let code = generator.description

                        self.printDiff(code: code, expected: self.expectedCode(CoreType.moduleOneAction))

                        expect(code) == self.expectedCode(CoreType.moduleOneAction)
                    }
                }
                
                describe("byInserting(action:in:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "Module/Core/Core/ModuleOneAction.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }
                    
                    it("should rewrite the action file with one more action") {
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
            
            describe("ModuleUIAction") {
                var generator: ModuleUIAction!
                
                beforeEach {
                    generator = ModuleUIAction(moduleName: "ModuleOne")
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
                    let filePath = "Module/ModuleOne/ModuleOne/ModuleOneAction.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }
                    
                    it("should rewrite the action file with one more action") {
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
            
            describe("CoreAppAction") {
                var generator: CoreAppAction!

                beforeEach {
                    generator = CoreAppAction()
                }
                
                describe("description") {
                    it("should return a string containing the action's code") {
                        let code = generator.description
                        
                        self.printDiff(code: code, expected: self.expectedCode(CoreType.appAction))
                        
                        expect(code) == self.expectedCode(CoreType.appAction)
                    }
                }
                
                describe("insert(action:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "Module/Core/Core/AppAction.swift"
                    
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
