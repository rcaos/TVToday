//
//  AppFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking
import Persistence
import Shared

public struct AppDependencies {
  let apiDataTransferService: DataTransferService
  let appConfigurations: AppConfigurations
  let showsPersistence: ShowsVisitedLocalRepository
  let searchsPersistence: SearchLocalRepository
}

public enum AppChildCoordinator {
  case signed
  // case signUp, login, onboarding, etc
}

class AppCoordinator: NCoordinator {
  
  private let window: UIWindow
  
  private let dependencies: AppDependencies
  
  var childCoordinators = [AppChildCoordinator: NCoordinator]()
  
  // MARK: - Initializer
  
  public init(window: UIWindow, dependencies: AppDependencies) {
    self.window = window
    self.dependencies = dependencies
  }
  
  func start() {
    nagivateToSignedFlow()
  }
  
  fileprivate func nagivateToSignedFlow() {
    
    let signedDependencies = SignedDependencies(
      apiDataTransferService: dependencies.apiDataTransferService,
      appConfigurations: dependencies.appConfigurations,
      showsPersistence: dependencies.showsPersistence,
      searchsPersistence: dependencies.searchsPersistence)
    
    let tabBar = UITabBarController()
    let coordinator = SignedCoordinator(tabBarController: tabBar, dependencies: signedDependencies)
    
    self.window.rootViewController = tabBar
    self.window.makeKeyAndVisible()
    
    childCoordinators[.signed] = coordinator
    coordinator.start()
  }
}
