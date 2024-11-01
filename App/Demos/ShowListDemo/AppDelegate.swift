//
//  Created by Jeans Ruiz on 21/04/22.
//

import UIKit
import Networking
import NetworkingInterface

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var coordinator: ShowListDemoCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let appConfigurations = buildAppConfigurations()
    coordinator = ShowListDemoCoordinator(
      window: window!,
      tabBarController: UITabBarController(),
      apiClient: buildApiClient(appConfigurations: appConfigurations),
      imagesBaseURL: appConfigurations.imagesBaseURL
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
