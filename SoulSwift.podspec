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

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SoulSwift' => ['SoulSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Moya', '~> 13.0'
  s.dependency 'Starscream', '~> 3.0.2'
  s.dependency 'Swinject', '~> 2.5'
  s.dependency 'SwinjectAutoregistration', '~> 2.5'
end
