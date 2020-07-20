//
//  AppDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Networking
import Persistence
import RealmPersistence
import Shared

import AiringToday
import PopularShows
import SearchShows

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
  
  func buildAiringTodayModule() -> AiringToday.Module {
    let dependencies = AiringToday.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                      showsPersistence: showsPersistence)
    return AiringToday.Module(dependencies: dependencies)
  }
  
  // MARK: - Popular Module
  
  func buildPopularModule() -> PopularShows.Module {
    let dependencies = PopularShows.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                       imagesBaseURL: appConfigurations.imagesBaseURL, showsPersistence: showsPersistence)
    return PopularShows.Module(dependencies: dependencies)
  }
  
  // MARK: - Search Module
  
  func buildSearchModule() -> SearchShows.Module {
    let dependencies = SearchShows.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                      showsPersistence: showsPersistence,
                                                      searchsPersistence: searchPersistence)
    return SearchShows.Module(dependencies: dependencies)
  }
}
