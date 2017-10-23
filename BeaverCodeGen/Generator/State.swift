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
            \(moduleNames.count > 0 ? moduleNames.map {
                "public var \($0.varName)State: \($0.typeName)State?"
            }.joined(separator: br(.tab)).br : "")
            public init() {
            }
        }
        
        extension AppState {
            public static func ==(lhs: AppState, rhs: AppState) -> Bool {
                return \(moduleNames.count > 0 ? moduleNames.map {
                    "lhs.\($0.varName)State == rhs.\($0.varName)State"
                }.joined(separator: " &&".br.tab(3)) : "true")
            }
        }
        
        """
    }
    
    func insert(module moduleName: String, in fileHandler: FileHandling) {
        let swiftFile = SwiftFile.read(from: fileHandler, atPath: path)
        
        guard let stateStruct = swiftFile.find(recursive: true, isMatching:  {
            $0.typeName == .appState && $0.kind == .`struct` && $0.doesInherit(from: [.beaverState])
        }).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find AppState in \(fileHandler)")
        }
        
        let moduleVars = stateStruct.find { ($0.typeName?.isModuleState ?? false) && $0.kind == .`var` }
        let varOffset = moduleVars.last?.offset ?? stateStruct.offset

        if moduleVars.count > 0 {
            fileHandler.insert(content: "public var \(moduleName.varName)State: \(moduleName.typeName)State?".br.indented,
                               atOffset: varOffset,
                               withSelector: .matching(string: .br, insert: .after),
                               inFileAtPath: path)
        } else {
            fileHandler.insert(content: "public var \(moduleName.varName)State: \(moduleName.typeName)State?".br,
                               atOffset: varOffset,
                               withSelector: .matching(string: .br + .tab, insert: .after),
                               inFileAtPath: path)
        }

        guard let equalOperator = swiftFile.find(recursive: true, isMatching: {
            $0.typeName == .equalOperator && $0.kind == .staticMethod && $0.parent?.typeName == .appState
        }).first as? SwiftScanable & SwiftIndexable else {
            fatalError("Couldn't find AppState.==(_:_:) in \(fileHandler)")
        }

        guard let equalOffset = equalOperator.endOffset else {
            fatalError("Couldn't compute offset to insert at in \(fileHandler)")
        }

        let equalString = "lhs.\(moduleName.varName)State == rhs.\(moduleName.varName)State"
        if moduleVars.count > 0 {
            fileHandler.insert(content: " &&".br + equalString.indented(count: 3),
                               atOffset: equalOffset,
                               withSelector: .matching(string: .br, insert: .before),
                               inFileAtPath: path)
        } else {
            fileHandler.insert(content: "return " + equalString,
                               atOffset: equalOffset,
                               withSelector: .matching(string: "return true", insert: .over),
                               inFileAtPath: path)
        }
    }
}
