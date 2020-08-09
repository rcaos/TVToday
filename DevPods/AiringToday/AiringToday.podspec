
Pod::Spec.new do |s|
  s.name             = 'AiringToday'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AiringToday.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Jeans Ruiz/AiringToday'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeans Ruiz' => 'jeansruiz.c@gmail.com' }
  s.source           = { :git => 'https://github.com/Jeans Ruiz/AiringToday.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'AiringToday/Module/**/*.{swift}'
  
  s.resource = 'AiringToday/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'
  
  # Development pods dependencies
  s.dependency 'Shared'
  s.dependency 'UI'
  s.dependency 'Networking'
  s.dependency 'ShowDetails'
  s.dependency 'Persistence'

  # Third Party Frameworks
  s.dependency 'RxSwift', '~> 5.0.0'
  s.dependency 'RxCocoa', '~> 5.0.0'
  s.dependency 'RxDataSources', '~> 4.0.0'
  

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'AiringToday/Tests/**/*.{swift}'

    test_spec.dependency 'Quick'
    test_spec.dependency 'Nimble'
    test_spec.dependency 'iOSSnapshotTestCase'
    
    test_spec.dependency 'RxTest'
    test_spec.dependency 'RxBlocking'
  end
end
