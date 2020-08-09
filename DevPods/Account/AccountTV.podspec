#
# Be sure to run `pod lib lint Account.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AccountTV'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Account.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Jeans Ruiz/AccountTV'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeans Ruiz' => 'jeansruiz.c@gmail.com' }
  s.source           = { :git => 'https://github.com/Jeans Ruiz/AccountTV.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'Account/Module/**/*.{swift}'
  
  s.resource = 'Account/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'
  
  # Development pods dependencies
  s.dependency 'Shared'
  s.dependency 'UI'
  s.dependency 'Networking'
  s.dependency 'TVShowsList'
  s.dependency 'Persistence'

  # Third Party Frameworks
  s.dependency 'RxSwift', '~> 5.0.0'
  s.dependency 'RxCocoa', '~> 5.0.0'
  s.dependency 'RxDataSources', '~> 4.0.0'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Account/Tests/**/*.{swift}'

    test_spec.dependency 'Quick'
    test_spec.dependency 'Nimble'
    test_spec.dependency 'iOSSnapshotTestCase'
    
    test_spec.dependency 'RxTest'
    test_spec.dependency 'RxBlocking'
  end
end
