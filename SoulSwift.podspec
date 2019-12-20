#
# Be sure to run `pod lib lint SoulSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoulSwift'
  s.version          = '1.0.3'
  s.summary          = 'SoulSwift for soulplatform.com'

  s.homepage         = 'https://github.com/vandyshev/SoulSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgenii Vandyshev' => 'e.vandyshev@gmail.com' }
  s.source           = { :git => 'https://github.com/vandyshev/SoulSwift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/e_vandyshev'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.subspec 'Soul' do |ss|
    ss.source_files = 'Sources/Soul/Classes/**/*'
    ss.dependency 'CryptoSwift', '~> 1.0'
    ss.dependency 'Swinject', '~> 2.5'
    ss.dependency 'SwinjectAutoregistration', '~> 2.5'
  end
end
