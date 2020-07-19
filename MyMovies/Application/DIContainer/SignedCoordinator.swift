//
//  SignedFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

import Networking
import AiringToday
import PopularShows
import SearchShows
import Account
import Shared
import Persistence

// MARK: - TODO:

public struct SignedDependencies {
  let apiDataTransferService: DataTransferService
  let appConfigurations: AppConfigurations
  let showsPersistence: ShowsVisitedLocalRepository
  let searchsPersistence: SearchLocalRepository
}

public enum SignedChildCoordinator {
  case airingToday
  
  // MARK: - TODO
  // popularShows
  // search
  // account
}

public class SignedCoordinator: NCoordinator {
  
  public var tabBarController: UITabBarController
  
  public var childCoordinators = [SignedChildCoordinator: NCoordinator]()
  
  private let dependencies: SignedDependencies
  
  // MARK: - Life Cycle
  
  public init(tabBarController: UITabBarController, dependencies: SignedDependencies) {
    self.tabBarController = tabBarController
    self.dependencies = dependencies
  }
  
  public func start() {
    showMainFeatures()
  }
  
  fileprivate func showMainFeatures() {
    
    let coordinatorDependencies =
      AiringTodayDependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        imagesBaseURL: dependencies.appConfigurations.imagesBaseURL,
        showsPersistence: dependencies.showsPersistence)
    
    let navigation = UINavigationController()
    let coordinator = AiringTodayCoordinator(navigationController: navigation,
                                             dependencies: coordinatorDependencies)
    
    let item = UITabBarItem(title: "Today", image: UIImage(name: "calendar"), tag: 0)
    coordinator.navigationController.tabBarItem = item
    tabBarController.setViewControllers([navigation], animated: true)
    
    childCoordinators[.airingToday] = coordinator
    coordinator.start()
  }
}
