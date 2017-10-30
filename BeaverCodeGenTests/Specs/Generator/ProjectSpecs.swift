import Quick
import Nimble

@testable import BeaverCodeGen

final class ProjectSpecs: QuickSpec {
    override func spec() {
        describe("Project") {
            var fileHandlerMock: FileHandlerMock!
            var moduleNames: [String]!
            var generator: ProjectGenetator!
            
            beforeEach {
                fileHandlerMock = FileHandlerMock()
                moduleNames = ["Test1", "Test2"]
                generator = ProjectGenetator(name: "Test", moduleNames: moduleNames)
            }
            
            describe("generateProject") {
                it("generates the code and stores it on the file system") {
                    generator.generate(in: fileHandlerMock)
                    
                    expect(fileHandlerMock.paths.count) == 23
                    
                    // Cakefile
                    
                    expect(fileHandlerMock.paths["Cakefile"]) == 1
                    expect(fileHandlerMock.contents["Cakefile"]) == RootCakefile().description
                    
                    expect(fileHandlerMock.paths["Module/Core/Cakefile.rb"]) == 1
                    expect(fileHandlerMock.contents["Module/Core/Cakefile.rb"]) == TargetCakefile(targetName: "Core").description

                    expect(fileHandlerMock.paths["Module/Test1/Cakefile.rb"]) == 1
                    expect(fileHandlerMock.contents["Module/Test1/Cakefile.rb"]) == TargetCakefile(targetName: "Test1").description

                    expect(fileHandlerMock.paths["Module/Test2/Cakefile.rb"]) == 1
                    expect(fileHandlerMock.contents["Module/Test2/Cakefile.rb"]) == TargetCakefile(targetName: "Test2").description

                    // Podfile
                    
                    expect(fileHandlerMock.paths["Podfile"]) == 1
                    expect(fileHandlerMock.contents["Podfile"]) == RootPodfile().description
                    
                    expect(fileHandlerMock.paths["Module/Core/Podfile.rb"]) == 1
                    expect(fileHandlerMock.contents["Module/Core/Podfile.rb"]) == TargetPodfile(targetName: "Core").description
                    
                    expect(fileHandlerMock.paths["Module/Test1/Podfile.rb"]) == 1
                    expect(fileHandlerMock.contents["Module/Test1/Podfile.rb"]) == TargetPodfile(targetName: "Test1").description
                    
                    expect(fileHandlerMock.paths["Module/Test2/Podfile.rb"]) == 1
                    expect(fileHandlerMock.contents["Module/Test2/Podfile.rb"]) == TargetPodfile(targetName: "Test2").description
                    
                    // App
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/AppState.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Core/Core/AppState.swift"]) == BeaverCodeGen.AppState(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppAction.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppAction.swift"]) == BeaverCodeGen.AppAction().description
                    
                    expect(fileHandlerMock.paths["App/AppReducer.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppReducer.swift"]) == BeaverCodeGen.AppReducer(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppPresenter.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppPresenter.swift"]) == BeaverCodeGen.AppPresenter(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppDelegate.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppDelegate.swift"]) == BeaverCodeGen.AppDelegate().description

                    // Test1 Module

                    expect(fileHandlerMock.paths["Module/Core/Core/Test1State.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Core/Core/Test1State.swift"]) == ModuleState(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Action.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test1/Test1/Test1Action.swift"]) == ModuleAction(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Reducer.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test1/Test1/Test1Reducer.swift"]) == ModuleReducer(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Presenter.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test1/Test1/Test1Presenter.swift"]) == ModulePresenter(moduleName: "Test1").description

                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1ViewController.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test1/Test1/Test1ViewController.swift"]) == ViewController(moduleName: "Test1").description
                    
                    // Test2 Module
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/Test2State.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Core/Core/Test2State.swift"]) == ModuleState(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Action.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test2/Test2/Test2Action.swift"]) == ModuleAction(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Reducer.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test2/Test2/Test2Reducer.swift"]) == ModuleReducer(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Presenter.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test2/Test2/Test2Presenter.swift"]) == ModulePresenter(moduleName: "Test2").description
                    
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2ViewController.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test2/Test2/Test2ViewController.swift"]) == ViewController(moduleName: "Test2").description
                }
            }
            
            describe("byInserting(module:in:)") {
                it("generates the code and stores it on the file system") {
                    generator.generate(in: fileHandlerMock)

                    _ = generator.byInserting(module: "Test3", in: fileHandlerMock)
                    
                    moduleNames = moduleNames + ["Test3"]
                    
                    // App
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/AppState.swift"]) >= 2
                    expect(fileHandlerMock.contents["Module/Core/Core/AppState.swift"]) == BeaverCodeGen.AppState(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppAction.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppAction.swift"]) == BeaverCodeGen.AppAction().description
                    
                    expect(fileHandlerMock.paths["App/AppReducer.swift"]) >= 2
                    expect(fileHandlerMock.contents["App/AppReducer.swift"]) == BeaverCodeGen.AppReducer(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppPresenter.swift"]) >= 2
                    expect(fileHandlerMock.contents["App/AppPresenter.swift"]) == BeaverCodeGen.AppPresenter(moduleNames: moduleNames).description
                    
                    expect(fileHandlerMock.paths["App/AppDelegate.swift"]) == 1
                    expect(fileHandlerMock.contents["App/AppDelegate.swift"]) == BeaverCodeGen.AppDelegate().description
                    
                    // Test1 Module
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/Test1State.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Action.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Reducer.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Presenter.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1ViewController.swift"]) == 1
                    
                    // Test2 Module
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/Test2State.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Action.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Reducer.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Presenter.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2ViewController.swift"]) == 1
                    
                    // Test3 Module
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/Test3State.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Core/Core/Test3State.swift"]) == ModuleState(moduleName: "Test3").description
                    
                    expect(fileHandlerMock.paths["Module/Test3/Test3/Test3Action.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test3/Test3/Test3Action.swift"]) == ModuleAction(moduleName: "Test3").description
                    
                    expect(fileHandlerMock.paths["Module/Test3/Test3/Test3Reducer.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test3/Test3/Test3Reducer.swift"]) == ModuleReducer(moduleName: "Test3").description
                    
                    expect(fileHandlerMock.paths["Module/Test3/Test3/Test3Presenter.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test3/Test3/Test3Presenter.swift"]) == ModulePresenter(moduleName: "Test3").description
                    
                    expect(fileHandlerMock.paths["Module/Test3/Test3/Test3ViewController.swift"]) == 1
                    expect(fileHandlerMock.contents["Module/Test3/Test3/Test3ViewController.swift"]) == ViewController(moduleName: "Test3").description
                }
            }
            
            describe("byInserting(action:toModule:in:)") {
                it("generates the code and stores it on the file system") {
                    generator.generate(in: fileHandlerMock)
                    
                    let actionTest = ModuleAction.ActionType.routing(EnumCase(name: "ActionTest"))
                    _ = generator.byInserting(action: actionTest,
                                              toModule: "Test2",
                                              in: fileHandlerMock)
                    
                    // App
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/AppState.swift"]) == 1
                    expect(fileHandlerMock.paths["App/AppAction.swift"]) == 1
                    expect(fileHandlerMock.paths["App/AppReducer.swift"]) == 1
                    expect(fileHandlerMock.paths["App/AppPresenter.swift"]) == 1
                    expect(fileHandlerMock.paths["App/AppDelegate.swift"]) == 1
                    
                    // Test1 Module
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/Test1State.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Action.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Reducer.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1Presenter.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test1/Test1/Test1ViewController.swift"]) == 1
                    
                    // Test2 Module
                    
                    expect(fileHandlerMock.paths["Module/Core/Core/Test2State.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Action.swift"]) >= 2
                    expect(fileHandlerMock.contents["Module/Test2/Test2/Test2Action.swift"]) == ModuleAction(moduleName: "Test2", actions: [actionTest]).description
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Reducer.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2Presenter.swift"]) == 1
                    expect(fileHandlerMock.paths["Module/Test2/Test2/Test2ViewController.swift"]) == 1
                }
            }
        }
    }
}
