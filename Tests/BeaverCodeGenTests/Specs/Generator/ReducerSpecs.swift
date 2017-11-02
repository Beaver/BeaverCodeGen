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
                var generator: BeaverCodeGen.AppReducer!
                
                beforeEach {
                    generator = BeaverCodeGen.AppReducer(moduleNames: ["ModuleOne", "ModuleTwo"])
                }
                
                describe("description") {
                    it("should return a string containing the Reducer's code") {
                        let code = generator.description
                        
                        self.printDiff(code: code, expected: self.expectedCode(AppType.reducer))

                        expect(code) == self.expectedCode(AppType.reducer)
                    }
                }
                
                describe("byInserting(module:in:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "App/AppReducer.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }

                    context("one or more modules already exist") {
                        beforeEach {
                            generator = BeaverCodeGen.AppReducer(moduleNames: ["ModuleOne", "ModuleTwo"])
                        }

                        it("should rewrite the reducer file with one more module") {
                            fileHandlerMock.contents[filePath] = generator.description
                            generator = generator.byInserting(module: "Test", in: fileHandlerMock)
                            expect(fileHandlerMock.contents[filePath]) == generator.description
                        }
                    }

                    context("one or more modules already exist") {
                        beforeEach {
                            generator = BeaverCodeGen.AppReducer(moduleNames: [])
                        }

                        it("should rewrite the reducer file with one module") {
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
