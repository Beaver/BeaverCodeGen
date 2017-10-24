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
                var generator: BeaverCodeGen.AppPresenter!
                
                beforeEach {
                    generator = BeaverCodeGen.AppPresenter(moduleNames: ["ModuleOne", "ModuleTwo"])
                }
                
                describe("description") {
                    it("should return a string containing the Presenter's code") {
                        let code = generator.description
                        
                        self.printDiff(code: code, expected: self.expectedCode(AppType.presenter))
                        
                        expect(code) == self.expectedCode(AppType.presenter)
                    }
                }
                
                describe("byInserting(module:in:)") {
                    var fileHandlerMock: FileHandlerMock!
                    let filePath = "App/AppPresenter.swift"
                    
                    beforeEach {
                        fileHandlerMock = FileHandlerMock()
                    }
                    
                    context("one or more modules already exist") {
                        beforeEach {
                            generator = BeaverCodeGen.AppPresenter(moduleNames: ["ModuleOne", "ModuleTwo"])
                        }
                        
                        it("should rewrite the reducer file with one more module") {
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
