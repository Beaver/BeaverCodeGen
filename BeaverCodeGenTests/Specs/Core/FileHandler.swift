import Quick
import Nimble

@testable import BeaverCodeGen

final class FileHandlerSpecs: QuickSpec {
    override func spec() {
        describe("FileHandler") {
            var fileHandler: FileHandler!
            let tmpDir = "/tmp/beaver_code_gen_specs"
            
            beforeEach {
                fileHandler = FileHandler()
            }
            
            describe("Read/Write") {
                func declareReadWriteSpecs(withTmpFilePath tmpFilePath: String) {
                    it("write a new file then read it") {
                        fileHandler.writeFile(atPath: tmpFilePath, content: "Test")
                        
                        let fileContent = fileHandler.readFile(atPath: tmpFilePath)
                        
                        expect(fileContent) == "Test"
                    }
                    
                    it("write a new file then update and read it") {
                        fileHandler.writeFile(atPath: tmpFilePath, content: "Test")
                        fileHandler.writeFile(atPath: tmpFilePath, content: "Updated Test")
                        
                        let fileContent = fileHandler.readFile(atPath: tmpFilePath)
                        
                        expect(fileContent) == "Updated Test"
                    }
                    
                    afterEach {
                        let tmpDirToRemove = tmpFilePath
                            .split(separator: "/")
                            .filter { !$0.isEmpty }
                            .joined(separator: "/")
                        _ = try? FileManager().removeItem(atPath: tmpDirToRemove)
                    }
                }

                context("When path is absolute") {
                    declareReadWriteSpecs(withTmpFilePath: "\(tmpDir)/file")
                }
                
                context("when path is relative") {
                    context("when path begins with ./") {
                        declareReadWriteSpecs(withTmpFilePath: ".\(tmpDir)/file")
                    }
                    
                    context("when path doesn't begin with ./") {
                        var path = "\(tmpDir)/file"
                        path.removeFirst()
                        declareReadWriteSpecs(withTmpFilePath: path)
                    }
                }
            }
            
            afterEach {
                _ = try? FileManager().removeItem(atPath: tmpDir)
            }
        }
    }
}
