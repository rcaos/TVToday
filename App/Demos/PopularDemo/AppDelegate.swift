//
//  AppDelegate.swift
//  PopularDemo
//
//  Created by Jeans Ruiz on 20/04/22.
//

import UIKit
import PopularsFeatureDemo
import Networking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var coordinator: PopularDemoCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let appConfigurations = buildAppConfigurations()
    let apiDataTransferService = buildDataTransferService(appConfigurations: appConfigurations)
    coordinator = PopularDemoCoordinator(window: window!,
                                         tabBarController: UITabBarController(),
                                         apiDataTransferService: apiDataTransferService,
                                         imagesBaseURL: appConfigurations.imagesBaseURL)
    coordinator?.start()
    return true
  }
}

func buildDataTransferService(appConfigurations: AppConfigurations) -> DefaultDataTransferService {
  let queryParameters = [
    "api_key": appConfigurations.apiKey,
    "language": NSLocale.preferredLanguages.first ?? "en"
  ]

  let configuration = ApiDataNetworkConfig(
    baseURL: appConfigurations.apiBaseURL,
    headers: [
      "Content-Type": "application/json; charset=utf-8"
    ],
    queryParameters: queryParameters
  )
  let networkService = DefaultNetworkService(config: configuration)
  return DefaultDataTransferService(with: networkService)
}

struct AppConfigurations {
  let apiKey: String
  let apiBaseURL: URL
  let imagesBaseURL: String
}

func buildAppConfigurations() -> AppConfigurations {
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

  return AppConfigurations(apiKey: apiKey, apiBaseURL: apiBaseURL, imagesBaseURL: imageBaseURL)
}

