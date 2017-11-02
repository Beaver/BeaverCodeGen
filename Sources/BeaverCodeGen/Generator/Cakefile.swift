struct RootCakefile: Generating {
    let path = "Cakefile"
}

extension RootCakefile {
    var description: String {
        return """
        # -- Global configuration --
        
        $DEPLOYMENT_TARGET = 9.0
        $CURRENT_SWIFT_VERSION = 4.0
        $COMPANY_IDENTIFIER = "com.beaver"
        $ORGANIZATION = "Beaver"
        $CURRENT_PROJECT_VERSION = "1"
        
        # -- Utils --
        
        MODULE_TARGETS = {}
        def module_target(name)
            if MODULE_TARGETS[name].nil?
                MODULE_TARGETS[name] = send("#{name}_target")
            end
            MODULE_TARGETS[name]
        end
        
        def snakecase(str)
            str.gsub(/([A-Z]+)([A-Z][a-z])/,'\\1_\\2')
                .gsub(/([a-z\\d])([A-Z])/,'\\1_\\2')
                .tr('-', '_')
                .gsub(/\\s/, '_')
                .gsub(/__+/, '_')
                .downcase
        end

        def declare_module_targets
            Dir["Module/*"].each { |module_path|
                require "./#{module_path}/Cakefile"
                module_name = snakecase(module_path.gsub("Module/", ""))
                module_target(module_name.to_sym)
            }
        end
        
        # Common configuration for all the targets
        def main_configuration(target, configuration)
            configuration.product_bundle_identifier = $COMPANY_IDENTIFIER + "." + target.name
        
            configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"
            configuration.settings["INFOPLIST_FILE"] = "#{target.name}/Info.plist"
            configuration.settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
            configuration.settings["SWIFT_VERSION"] = $CURRENT_SWIFT_VERSION
            configuration.settings["SDKROOT"] = "iphoneos"
            configuration.settings["DEBUG_INFORMATION_FORMAT"] = "dwarf"
            configuration.settings["TARGETED_DEVICE_FAMILY"] = "1,2"
            configuration.settings["IPHONEOS_DEPLOYMENT_TARGET"] = $DEPLOYMENT_TARGET
            configuration.settings["VERSIONING_SYSTEM"] = "apple-generic"
            configuration.settings["GCC_NO_COMMON_BLOCKS"] = "YES"
            configuration.settings["GCC_WARN_ABOUT_RETURN_TYPE"] = "YES_ERROR"
            configuration.settings["GCC_WARN_UNINITIALIZED_AUTOS"] = "YES_AGGRESSIVE"
            configuration.settings["CLANG_WARN_DIRECT_OBJC_ISA_USAGE"] = "YES_ERROR"
            configuration.settings["CLANG_WARN_OBJC_ROOT_CLASS"] = "YES_ERROR"
            configuration.settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Onone"
            configuration.settings["CURRENT_PROJECT_VERSION"] = $CURRENT_PROJECT_VERSION
            configuration.settings["CLANG_WARN_INFINITE_RECURSION"] = "YES"
            configuration.settings["CLANG_WARN_SUSPICIOUS_MOVE"] = "YES"
            configuration.settings["ENABLE_STRICT_OBJC_MSGSEND"] = "YES"
            configuration.settings["ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES"] = "$(inherited)"
        
            if configuration.name == "Release"
                configuration.settings["DEBUG_INFORMATION_FORMAT"] = "dwarf-with-dsym"
                configuration.settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Owholemodule"
            end
        end
        
        # -- Project definition --
        
        project do |p|
            p.name = "App"
            p.organization = $ORGANIZATION
        end
        
        declare_module_targets
        
        application_for :ios, $DEPLOYMENT_TARGET do |target|
            target.name = "App"
            target.language = :swift
            target.include_files = ["App/**/*.*"]
        
            target.linked_targets = MODULE_TARGETS.values
        
            target.all_configurations.each do |configuration|
                main_configuration(target, configuration)
                configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"
        
                configuration.supported_devices = :universal
            end
        
            unit_tests_for target do |test_target|
                test_target.name = "AppTests"
                test_target.include_files = ["AppTests/**/*.*"]
        
                test_target.all_configurations do |configuration|
                    main_configuration(target, configuration)
                    configuration.settings["INFOPLIST_FILE"] = "#{test_target.name}/Info.plist"
                end
            end
        end
        
        project.after_save do
            `pod install`
        end
        
        """
    }
}

struct TargetCakefile: Generating {
    let targetName: String
    
    var path: String {
        return "Module/\(targetName.typeName)/Cakefile.rb"
    }
}

extension TargetCakefile {
    var description: String {
        return """
        def \(targetName.snakecase)_target()
            target do |target|
                target.name = "\(targetName)"
                target.platform = :ios
                target.deployment_target = $DEPLOYMENT_TARGET
                target.type = :framework
                target.language = :swift
                target.include_files = ["Module/#{target.name}/#{target.name}/**/*.*"]
                target.exclude_files << "**/Info.plist"
        
                unit_tests_for target do |test_target|
                    test_target.name = "#{target.name}Tests"
                    test_target.include_files = ["Module/#{target.name}/#{target.name}Tests/**/*.*"]
                    target.exclude_files << "**/Info.plist"
        
                    test_target.all_configurations do |configuration|
                        main_configuration(test_target, configuration)
                        configuration.settings["INFOPLIST_FILE"] = "Module/#{target.name}/#{test_target.name}/Info.plist"
                    end
                end
        
                target.all_configurations.each do |configuration|
                    main_configuration(target, configuration)
                    configuration.settings["INFOPLIST_FILE"] = "Module/#{target.name}/#{target.name}/Info.plist"
                end
            end
        end
        
        """
    }
}
