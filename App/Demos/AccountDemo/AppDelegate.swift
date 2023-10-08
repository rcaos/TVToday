//
//  AppDelegate.swift
//  AccountDemo
//
//  Created by Jeans Ruiz on 20/04/22.
//

import UIKit
import AccountFeatureDemo
import Networking
import NetworkingInterface

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var coordinator: AccountFeatureDemoCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let appConfigurations = buildAppConfigurations()
    coordinator = AccountFeatureDemoCoordinator(
      window: window!,
      tabBarController: UITabBarController(),
      apiClient: buildApiClient(appConfigurations: appConfigurations),
      imagesBaseURL: appConfigurations.imagesBaseURL,
      gravatarBaseURL: appConfigurations.gravatarBaseURL,
      authenticateBaseURL: appConfigurations.authenticateBaseURL
    )
    coordinator?.start()
    return true
  }
}

private func buildApiClient(appConfigurations: AppConfigurations) -> ApiClient {
  let config = NetworkConfig(
    baseURL: appConfigurations.apiBaseURL,
    headers: [
      "Content-Type": "application/json; charset=utf-8"
    ],
    queryParameters: [
      "api_key": appConfigurations.apiKey,
      "language": NSLocale.preferredLanguages.first ?? "en"
    ]
  )
  return ApiClient.live(networkConfig: config)
}

struct AppConfigurations {
  let apiKey: String
  let apiBaseURL: URL
  let imagesBaseURL: String
  let authenticateBaseURL: String
  let gravatarBaseURL: String
}

private func buildAppConfigurations() -> AppConfigurations {
  guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
    fatalError("ApiKey must not be empty in plist")
  }

  guard let apiBaseString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
    fatalError("ApiBaseURL must not be empty in plist")
  }

  guard let apiBaseURL = URL(string: apiBaseString) else {
    fatalError("Could not convert \(apiBaseString) into a URL")
  }

  guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "IMAGE_BASE_URL") as? String else {
    fatalError("ApiBaseURL must not be empty in plist")
  }

  guard let authenticateBaseURL = Bundle.main.object(forInfoDictionaryKey: "AUTHENTICATE_BASE_URL") as? String else {
    fatalError("Authenticate Base URL must not be empty in plist")
  }

  guard let gravatarBaseURL = Bundle.main.object(forInfoDictionaryKey: "GRAVATAR_BASE_URL") as? String else {
    fatalError("Gravatar BaseURL Base URL must not be empty in plist")
  }

  return AppConfigurations(apiKey: apiKey, apiBaseURL: apiBaseURL,
                           imagesBaseURL: imageBaseURL,
                           authenticateBaseURL: authenticateBaseURL,
                           gravatarBaseURL: gravatarBaseURL)
}
