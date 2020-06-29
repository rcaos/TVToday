# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

workspace 'TVToday.xcworkspace'
project 'TVToday.xcodeproj'

def networking_pod
  pod 'Networking', :path =>  'DevPods/Networking'
end

def account_pod
  pod 'Account', :path =>  'DevPods/Account'
end

def shared_pod
  pod 'Shared', :path =>  'DevPods/Shared'
end

def airingToday_pod
  pod 'AiringToday', :path =>  'DevPods/AiringToday'
end

def popularShows_pod
  pod 'PopularShows', :path =>  'DevPods/PopularShows'
end

def searchShows_pod
  pod 'SearchShows', :path =>  'DevPods/SearchShows'
end

def showsList_pod
  pod 'TVShowsList', :path =>  'DevPods/TVShowsList'
end

def showDetails_pod
  pod 'ShowDetails', :path =>  'DevPods/ShowDetails'
end

def keychain_pod
  pod 'KeyChainStorage', :path =>  'DevPods/KeyChainStorage'
end


def development_pods
  networking_pod
  account_pod
  shared_pod
  airingToday_pod
  popularShows_pod
  searchShows_pod
  showsList_pod
  showDetails_pod
  keychain_pod
end

target 'TVToday' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TVToday
  # pod 'Kingfisher',      '5.13.0'
  
  pod 'RxSwift',         '5.0.0'
  pod 'RxCocoa',         '5.0.0'
  pod 'RxDataSources',   '4.0.0'
  
  pod 'RxFlow',          '2.7.0'
  #pod 'KeychainSwift', 	 '14.0'
  
   # Dev Pods
   development_pods
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  
  networking_pod
end

target 'Account_Example' do
  use_frameworks!
  project 'DevPods/Account/Example/Account.xcodeproj'
  
  account_pod
end

target 'Shared_Example' do
  use_frameworks!
  project 'DevPods/Shared/Example/Shared.xcodeproj'
  
  shared_pod
end

target 'AiringToday_Example' do
  use_frameworks!
  project 'DevPods/AiringToday/Example/AiringToday.xcodeproj'
  
  airingToday_pod
end

target 'PopularShows_Example' do
  use_frameworks!
  project 'DevPods/PopularShows/Example/PopularShows.xcodeproj'
  
  popularShows_pod
end

target 'SearchShows_Example' do
  use_frameworks!
  project 'DevPods/SearchShows/Example/SearchShows.xcodeproj'
  
  searchShows_pod
end

target 'TVShowsList_Example' do
  use_frameworks!
  project 'DevPods/TVShowsList/Example/TVShowsList.xcodeproj'
  
  showsList_pod
end

target 'ShowDetails_Example' do
  use_frameworks!
  project 'DevPods/ShowDetails/Example/ShowDetails.xcodeproj'
  
  showDetails_pod
end

target 'KeyChainStorage_Example' do
  use_frameworks!
  project 'DevPods/KeyChainStorage/Example/KeyChainStorage.xcodeproj'
  
  keychain_pod
end

