#
# Be sure to run `pod lib lint PopularShows.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PopularShows'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PopularShows.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Jeans Ruiz/PopularShows'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeans Ruiz' => 'jeansruiz.c@gmail.com' }
  s.source           = { :git => 'https://github.com/Jeans Ruiz/PopularShows.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'PopularShows/Module/**/*.{swift}'
  
  s.resource = 'PopularShows/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'
  
  # Development pods dependencies
  s.dependency 'Shared'
  s.dependency 'Networking'
  s.dependency 'ShowDetails'
  s.dependency 'Persistence'

  # Third Party Frameworks
  s.dependency 'RxSwift', '~> 5.0.0'
  s.dependency 'RxCocoa', '~> 5.0.0'
  s.dependency 'RxDataSources', '~> 4.0.0'
  s.dependency 'RxFlow', '~> 2.7.0'
  
  # s.resource_bundles = {
  #   'PopularShows' => ['PopularShows/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
