inhibit_all_warnings!
use_frameworks!

platform :osx, '10.10'

target 'BeaverCodeGen' do
  pod 'SourceKittenFramework'

  target 'BeaverCodeGenTests' do
    pod 'Beaver', :git => 'git@github.com:Beaver/Beaver.git'
    
    target 'Core' do
    end

    target 'ModuleOne' do
    end

    target 'ModuleTwo' do
    end

    pod 'Quick'
    pod 'Nimble'
    pod 'Diff', :git => 'git@github.com:wokalski/Diff.swift.git', :branch => 'swift-4.0'
  end
end
