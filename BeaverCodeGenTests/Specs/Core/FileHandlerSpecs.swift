import Quick
import Nimble

@testable import BeaverCodeGen

final class FileHandlerSpecs: QuickSpec {
    override func spec() {
        describe("FileHandler") {
            let tmpDir = "/tmp/beaver_code_gen_specs"
            
            describe("Read/Write") {
                func declareReadWriteSpecs(withDirPath dirPath: String, filePath: String) {
                    it("write a new file then read it") {
                        let fileHandler = FileHandler(dirPath: dirPath)
                        
                        fileHandler.writeFile(atPath: filePath, content: "Test")
                        
                        let fileContent = fileHandler.readFile(atPath: filePath)
                        
                        expect(fileContent) == "Test"
                    }
                    
                    it("write a new file then update and read it") {
                        let fileHandler = FileHandler(dirPath: dirPath)

                        fileHandler.writeFile(atPath: filePath, content: "Test")
                        fileHandler.writeFile(atPath: filePath, content: "Updated Test")
                        
                        let fileContent = fileHandler.readFile(atPath: filePath)
                        
                        expect(fileContent) == "Updated Test"
                    }
                    
                    afterEach {
                        _ = try? FileManager().removeItem(atPath: dirPath)
                    }
                }

                context("When path is absolute") {
                    declareReadWriteSpecs(withDirPath: tmpDir, filePath: "file")
                }
                
                context("when path is relative") {
                    context("when path begins with ./") {
                        declareReadWriteSpecs(withDirPath: ".\(tmpDir)", filePath: "file")
                    }
                    
                    context("when path doesn't begin with ./") {
                        var path = tmpDir
                        path.removeFirst()
                        declareReadWriteSpecs(withDirPath: path, filePath: "file")
                    }
                }
            }
            
            afterEach {
                _ = try? FileManager().removeItem(atPath: tmpDir)
            }
        }
    }
}
