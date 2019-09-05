#
# Be sure to run `pod lib lint SoulSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoulSwift'
  s.version          = '0.2.2'
  s.summary          = 'A short description of SoulSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Evgeny Vandyshev/SoulSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeny Vandyshev' => 'evgeny.vandyshev@soulplatform.com' }
  s.source           = { :git => 'https://github.com/Evgeny Vandyshev/SoulSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/e_vandyshev'
  s.default_subspec = 'Core'

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'SoulSwift' => ['SoulSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Classes/**/*'
    ss.dependency 'Swinject', '~> 2.5'
    ss.dependency 'SwinjectAutoregistration', '~> 2.5'
  end

  s.subspec 'Chats' do |ss|
    ss.source_files = 'Chats/Sources/Classes/**/*'
    ss.dependency "SoulSwift/Core"
    ss.dependency 'Moya', '~> 13.0'
    ss.dependency 'Starscream', '~> 3.0.2'
    ss.dependency 'Swinject', '~> 2.5'
    ss.dependency 'SwinjectAutoregistration', '~> 2.5'
  end
end
