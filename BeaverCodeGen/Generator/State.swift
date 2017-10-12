struct ModuleState: Generating {
    let objectType: ObjectType = .state
    let framework = "Core"
    let moduleName: String
}

extension ModuleState {
    var name: String {
        return moduleName
    }
    
    var description: String {
        return """
        import Beaver
        
        public struct \(moduleName.typeName)State: Beaver.State {
            public var error: String?
        
            public var currentScreen: CurrentScreen = .none
        
            public init() {
            }
        }
        
        extension \(moduleName.typeName)State {
            /// Represents the currently shown screen
            public enum CurrentScreen: Int {
                case none
                case main
            }
        }
        
        extension \(moduleName.typeName)State {
            public static func ==(lhs: \(moduleName.typeName)State, rhs: \(moduleName.typeName)State) -> Bool {
                return lhs.error == rhs.error &&
                    lhs.currentScreen == rhs.currentScreen
            }
        }
        
        """
    }
}

struct AppState: Generating {
    let objectType: ObjectType = .state
    let framework = "Core"
    let name = "App"
    var moduleNames: [String]
}

extension AppState: CustomStringConvertible {
    var description: String {
        return """
        import Beaver
        
        public struct AppState: Beaver.State {
            \(moduleNames.map {
                "public var \($0.varName)State: \($0.typeName)State?"
            }.joined(separator: br(.tab)))
        
            public init() {
            }
        }
        
        extension AppState {
            public static func ==(lhs: AppState, rhs: AppState) -> Bool {
                return \(moduleNames.map {
                    "lhs.\($0.varName)State == rhs.\($0.varName)State"
                }.joined(separator: " &&".br.tab(3)))
            }
        }
        
        """
    }
    
    func insert(module moduleName: String, in fileHandler: FileHandling) {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)
        
        guard let stateStruct = swiftFile.find(byType: { $0 == .appState },
                                               byKind: .`struct`,
                                               withInheritedType: [.beaverState],
                                               recursive: true).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find AppState in \(fileHandler)")
        }
        
        let lastModuleVar = stateStruct.find(byType: { $0?.isModuleState ?? false }, byKind: .instance).last
        let offset = lastModuleVar?.offset ?? stateStruct.offset

        fileHandler.insert(content: "public var \(moduleName.varName)State: \(moduleName.typeName)State".br.indented,
                           atOffset: offset,
                           atNextLine: true,
                           inFileAtPath: path)
        
    }
}
