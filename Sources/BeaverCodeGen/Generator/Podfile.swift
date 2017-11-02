struct RootPodfile: Generating {
    let path = "Podfile"
}

extension RootPodfile {
    var description: String {
        return """
        # -- Utils --
        
        def snakecase(str)
            str.gsub(/([A-Z]+)([A-Z][a-z])/,'\\1_\\2')
                .gsub(/([a-z\\d])([A-Z])/,'\\1_\\2')
                .tr('-', '_')
                .gsub(/\\s/, '_')
                .gsub(/__+/, '_')
                .downcase
        end
        
        # -- Require modules --
        
        Dir["./Module/*/Podfile.rb"].each { |path|
            require path
        }

        # -- Project configuration --

        platform :ios, '9.0'

        def test_pods
            pod 'Quick'
            pod 'Nimble'
        
            # Put your test dependencies here
        end

        def app_pods
        end

        abstract_target 'AbstractApp' do
            use_frameworks!
            workspace 'App.xcworkspace'

            pod 'Beaver', :git => 'https://github.com/Beaver/Beaver'

            # Put your common dependencies here

            target 'App' do
                # Modules pods declaration
                Dir["Module/*"].each { |module_path|
                    module_name = snakecase(module_path.gsub("Module/", ""))
                    send("#{module_name}_pods")
                }

                target 'AppTests' do
                    inherit! :search_paths

                    test_pods
                end
            end

            # Module targets declaration
            Dir["Module/*"].each { |module_path|
                module_name = snakecase(module_path.gsub("Module/", ""))
                send("#{module_name}_target")
            }
        end
        
        """
    }
}

struct TargetPodfile: Generating {
    let targetName: String
    
    var path: String {
        return "Module/\(targetName.typeName)/Podfile.rb"
    }
}

extension TargetPodfile {
    private var dependOnCore: Bool {
        return targetName != "Core"
    }

    var description: String {
        return """
        def \(targetName.snakecase)_pods
            # Put your target dependencies here
        end
        
        def \(targetName.snakecase)_target
            target '\(targetName.typeName)' do
                \(dependOnCore ? "core_pods" : "")
                \(targetName.snakecase)_pods
        
                target '\(targetName.typeName)Tests' do
                    inherit! :search_paths
        
                    test_pods
                end
            end
        end
        
        """
    }
}
