# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

workspace 'TVToday.xcworkspace'
project 'TVToday.xcodeproj'

def networking_pod
  pod 'Networking', :path =>  'DevPods/Networking'
end

def development_pods
  networking_pod
end

target 'TVToday' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TVToday
  pod 'Kingfisher',      '5.13.0'
  
  pod 'RxSwift',         '5.0.0'
  pod 'RxCocoa',         '5.0.0'
  pod 'RxDataSources',   '4.0.0'
  
  pod 'RxFlow',          '2.7.0'
  pod 'KeychainSwift', 	 '14.0'
  
   # Dev Pods
   development_pods
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  
  networking_pod
end
