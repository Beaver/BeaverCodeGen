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
                var generator: BeaverCodeGen.AppState!
                
                beforeEach {
                    generator = BeaverCodeGen.AppState(moduleNames: ["ModuleOne", "ModuleTwo"])
                }

                describe("description") {
                    it("should return a string containing the State's code") {
                        let code = generator.description
                        
                        self.printDiff(code: code, expected: self.expectedCode(CoreType.appState))
                        
                        expect(code) == self.expectedCode(CoreType.appState)
                    }
                }
                
                describe("byInserting(module:in:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "Core/AppState.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }

                    context("when inserting a second or more module") {
                        beforeEach {
                            generator = BeaverCodeGen.AppState(moduleNames: ["ModuleOne", "ModuleTwo"])
                        }
                        
                        it("should rewrite the state file with one more module") {
                            fileHandlerMock.contents[filePath] = generator.description
                            generator = generator.byInserting(module: "Test", in: fileHandlerMock)
                            expect(fileHandlerMock.contents[filePath]) == generator.description
                        }
                    }
                    
                    context("when inserting the first module") {
                        beforeEach {
                            generator = BeaverCodeGen.AppState(moduleNames: [])
                        }
                        
                        it("should rewrite the state file with one module") {
                            fileHandlerMock.contents[filePath] = generator.description
                            generator = generator.byInserting(module: "Test", in: fileHandlerMock)
                            expect(fileHandlerMock.contents[filePath]) == generator.description
                        }
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
