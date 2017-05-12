inhibit_all_warnings!
use_frameworks!

platform :osx, '10.10'

target 'BeaverCodeGen' do
  pod 'FileKit', '~> 4.0'

  target 'BeaverCodeGenTests' do
    pod 'Beaver', :git => 'git@github.com:Beaver/Beaver.git'
    pod 'Quick'
    pod 'Nimble'
    pod 'Diff'
  end
end

post_install do |installer|
  puts("Set Swift version to 3.0")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end