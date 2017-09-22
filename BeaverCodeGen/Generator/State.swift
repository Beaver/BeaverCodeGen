struct ModuleState {
    let moduleName: String
}

extension ModuleState: CustomStringConvertible {
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

struct AppState {
    let moduleNames: [String]
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
}
