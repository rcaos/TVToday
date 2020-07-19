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
  
  private var appCoordinator: AppCoordinator!
  
  // MARK: - Life Cycle
  
  public init(window: UIWindow) {
    let appDependencies = AppDependencies(apiDataTransferService: apiDataTransferService,
                                          appConfigurations: appConfigurations,
                                          showsPersistence: showsPersistence,
                                          searchsPersistence: searchPersistence)
    
    appCoordinator = AppCoordinator(window: window, dependencies: appDependencies)
    appCoordinator?.start()
  }
}
