//
//  AppDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxFlow
import Networking
import Persistence
import RealmPersistence

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
    return RealmDataStorage(maxStorageLimit: 10)
  }()
  
  lazy var showsPersistence: ShowsVisitedLocalRepository = {
    let localStorage = DefaultShowsVisitedLocalStorage(realmDataStack: realmDataStorage)
    return DefaultShowsVisitedLocalRepository(showsVisitedLocalStorage: localStorage)
  }()
  
  public let coordinator: FlowCoordinator!
  
  private var appFlow: AppFlow!
  
  // MARK: - Life Cycle
  
  public init(window: UIWindow) {
    
    self.coordinator = FlowCoordinator()
    
    self.appFlow = AppFlow(
      window: window,
      dependencies: AppFlow.Dependencies(
        apiDataTransferService: apiDataTransferService,
        appConfigurations: appConfigurations,
        showsPersistence: showsPersistence))
    
    // Base on some Conditions, guest, logged, etc, launch "appFlow" with "First Step"
    // AppFlow handle "Flows.whenReady"
    coordinator.coordinate(flow: appFlow,
                           with: OneStepper(withSingleStep: AppStep.applicationAuthorized) )
  }
}
