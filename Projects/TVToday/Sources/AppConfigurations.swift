//
//  AppConfigurations.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

// MARK: - TODO, Don't read from info.plist

final class AppConfigurations {
  
  lazy var apiKey: String = {
    return "06e1a8c1f39b7a033e2efb972625fee2"
//    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
//      fatalError("ApiKey must not be empty in plist")
//    }
//    return apiKey
  }()

  lazy var apiBaseURL: String = {
    return "https://api.themoviedb.org"
//    guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
//      fatalError("ApiBaseURL must not be empty in plist")
//    }
//    return apiBaseURL
  }()
  
  lazy var imagesBaseURL: String = {
    return "https://image.tmdb.org"
//    guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
//      fatalError("ApiBaseURL must not be empty in plist")
//    }
//    return imageBaseURL
  }()
}
