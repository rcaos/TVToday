//
//  AppConfigurations.swift
//  TVToday
//
//  Created by Jeans Ruiz on 19/04/22.
//

import AppFeature
import Foundation

final class AppConfigurations: AppConfigurationProtocol {

  lazy var apiKey: String = {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
      fatalError("ApiKey must not be empty in plist")
    }
    return apiKey
  }()

  lazy var apiBaseURL: URL = {
    guard let apiBaseString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
      fatalError("ApiBaseURL must not be empty in plist")
    }

    guard let apiBaseURL = URL(string: apiBaseString) else {
      fatalError("Could not convert \(apiBaseString) into a URL")
    }

    return apiBaseURL
  }()

  lazy var imagesBaseURL: String = {
    guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "IMAGE_BASE_URL") as? String else {
      fatalError("ApiBaseURL must not be empty in plist")
    }
    return imageBaseURL
  }()

  lazy var authenticateBaseURL: String = {
    guard let authenticateBaseURL = Bundle.main.object(forInfoDictionaryKey: "AUTHENTICATE_BASE_URL") as? String else {
      fatalError("Authenticate Base URL must not be empty in plist")
    }
    return authenticateBaseURL
  }()

  lazy var gravatarBaseURL: String = {
    guard let gravatarBaseURL = Bundle.main.object(forInfoDictionaryKey: "GRAVATAR_BASE_URL") as? String else {
      fatalError("Avatar Base URL must not be empty in plist")
    }
    return gravatarBaseURL
  }()
}
