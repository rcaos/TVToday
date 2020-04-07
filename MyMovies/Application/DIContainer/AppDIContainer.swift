//
//  AppDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxFlow

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
  
  lazy var imageTransferService: DataTransferService = {
    let configuration = ApiDataNetworkConfig(
      baseURL: appConfigurations.imagesBaseURL)
    return ApiClient(with: configuration)
  }()
  
  public let coordinator: FlowCoordinator!
  
  private var appFlow: AppFlow!
  
  // MARK: - Life Cycle
  
  public init(window: UIWindow) {
    
    self.coordinator = FlowCoordinator()
    
    self.appFlow = AppFlow(
      window: window,
      dependencies: AppFlow.Dependencies(apiDataTransferService: apiDataTransferService,
                           imageTransferService: imageTransferService))
    
    // Base on some Conditions, guest, logged, etc, launch "appFlow" with "First Step"
    // AppFlow handle "Flows.whenReady"
    coordinator.coordinate(flow: appFlow,
                           with: OneStepper(withSingleStep: AppStep.applicationAuthorized) )
  }
}
