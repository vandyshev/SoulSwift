platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'SoulSwift_Example' do
  pod 'SoulSwift', :path => '.'
  pod 'SwiftLint'

  target 'SoulSwift_Tests' do
    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
  end
end

#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['SWIFT_VERSION'] = '4.2'
#        end
#    end
#end