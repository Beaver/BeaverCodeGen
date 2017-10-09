import Quick
import Nimble

@testable import BeaverCodeGen

final class ProjectSpecs: QuickSpec {
    override func spec() {
        describe("Project") {
            var fileHandlerMock: FileHandlerMock!
            
            beforeEach {
                fileHandlerMock = FileHandlerMock()
            }
            
            describe("generateProject") {
                it("generates the code and stores it on the file system") {
                    let moduleNames = ["Test1", "Test2"]
                    let generator = ProjectGenetator(name: "Test",
                                                     moduleNames: moduleNames)
                    
                    generator.generate(in: fileHandlerMock)
                    
                    // App
                    
                    expect(fileHandlerMock.paths["App/AppState.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppState.swift"]) == BeaverCodeGen.AppState(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppAction.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppAction.swift"]) == BeaverCodeGen.AppAction().description
                    
                    expect(fileHandlerMock.paths["App/AppReducer.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppReducer.swift"]) == BeaverCodeGen.AppReducer(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppPresenter.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppPresenter.swift"]) == BeaverCodeGen.AppPresenter(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppDelegate.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppDelegate.swift"]) == BeaverCodeGen.AppDelegate().description

                    // Test1 Module

                    expect(fileHandlerMock.paths["Test1/Test1State.swift"]) == 1
                    expect(fileHandlerMock.contents["Test1/Test1State.swift"]) == ModuleState(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Test1/Test1Action.swift"]) == 1
                    expect(fileHandlerMock.contents["Test1/Test1Action.swift"]) == ModuleAction(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Test1/Test1Reducer.swift"]) == 1
                    expect(fileHandlerMock.contents["Test1/Test1Reducer.swift"]) == ModuleReducer(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Test1/Test1Presenter.swift"]) == 1
                    expect(fileHandlerMock.contents["Test1/Test1Presenter.swift"]) == ModulePresenter(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Test1/Test1ViewController.swift"]) == 1
                    expect(fileHandlerMock.contents["Test1/Test1ViewController.swift"]) == ViewController(moduleName: "Test1").description
                    
                    // Test2 Module
                    
                    expect(fileHandlerMock.paths["Test2/Test2State.swift"]) == 1
                    expect(fileHandlerMock.contents["Test2/Test2State.swift"]) == ModuleState(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Test2/Test2Action.swift"]) == 1
                    expect(fileHandlerMock.contents["Test2/Test2Action.swift"]) == ModuleAction(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Test2/Test2Reducer.swift"]) == 1
                    expect(fileHandlerMock.contents["Test2/Test2Reducer.swift"]) == ModuleReducer(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Test2/Test2Presenter.swift"]) == 1
                    expect(fileHandlerMock.contents["Test2/Test2Presenter.swift"]) == ModulePresenter(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Test2/Test2ViewController.swift"]) == 1
                    expect(fileHandlerMock.contents["Test2/Test2ViewController.swift"]) == ViewController(moduleName: "Test2").description
                }
            }
        }
    }
}
