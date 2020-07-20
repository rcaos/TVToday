//
//  AppDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Networking
import Persistence
import RealmPersistence
import Shared

import AiringToday

public class AppDIContainer {
  
  lazy var appConfigurations = AppConfigurations()
  
  lazy var apiDataTransferService: DataTransferService = {
    let queryParameters = [
      "api_key": appConfigurations.apiKey,
      "language": NSLocale.preferredLanguages.first ?? "en"]
    
    let configuration = ApiDataNetworkConfig(
      baseURL: appConfigurations.apiBaseURL,
      queryParameters: queryParameters)
    
    return ApiClient(with: configuration)
  }()
  
  lazy var realmDataStorage: RealmDataStorage = {
    return RealmDataStorage()
  }()
  
  lazy var showsPersistence: ShowsVisitedLocalRepository = {
    let localStorage = DefaultShowsVisitedLocalStorage(realmDataStack: realmDataStorage)
    return DefaultShowsVisitedLocalRepository(showsVisitedLocalStorage: localStorage)
  }()
  
  lazy var searchPersistence: SearchLocalRepository = {
    let localStorage = DefaultSearchLocalStorage(realmDataStack: realmDataStorage)
    return DefaultSearchLocalRepository(searchLocalStorage: localStorage)
  }()
  
  // MARK: - Airing Today Module
  
  func makeAiringTodayModule() -> AiringToday.Module {
    let dependencies = AiringToday.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                      showsPersistence: showsPersistence)
    return AiringToday.Module(dependencies: dependencies)
  }
}
