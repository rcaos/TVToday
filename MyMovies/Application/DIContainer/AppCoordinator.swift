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

// MARK: - TODO:

public struct AppDependencies {
  let apiDataTransferService: DataTransferService
  let appConfigurations: AppConfigurations
  let showsPersistence: ShowsVisitedLocalRepository
  let searchsPersistence: SearchLocalRepository
}

class AppCoordinator: FCoordinator {
  
  private let rootWindow: UIWindow
  
  private let dependencies: AppDependencies
  
  var root: FPresentable {
    let controller = UIViewController()
    controller.view.backgroundColor = .white
    return rootWindow.rootViewController ?? controller
  }
  
  var childCoordinators: [FCoordinator] = []
  
  var parentCoordinator: FCoordinator?
  
  public init(window: UIWindow, dependencies: AppDependencies) {
    self.rootWindow = window
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
    
    let signedCoordinator = SignedCoordinator(dependencies: signedDependencies)
    
    if let root = signedCoordinator.root as? UIViewController {
      self.rootWindow.rootViewController = root
      self.rootWindow.makeKeyAndVisible()
      
      signedCoordinator.start()
    }
  }
}
