def module_one_pods
    # Put your target dependencies here
end

def module_one_target
    target 'ModuleOne' do
        core_pods
        module_one_pods

        target 'ModuleOneTests' do
            inherit! :search_paths

            test_pods
        end
    end
end
