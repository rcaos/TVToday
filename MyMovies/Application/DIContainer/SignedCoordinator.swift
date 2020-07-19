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
  case
  
  airingToday,
  
  popularShows
  
  // MARK: - TODO
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
    let (todayVC, todayCoordinator) = buildTodayCoordinator()
    let (popularVC, popularCoordinator) = buildPopularCoordinator()
    
    tabBarController.setViewControllers([todayVC, popularVC], animated: true)
    
    childCoordinators[.airingToday] = todayCoordinator
    childCoordinators[.popularShows] = popularCoordinator
  }
  
  // MARK: - Build Airing Today Coordinator
  
  fileprivate func buildTodayCoordinator() -> (UIViewController, NCoordinator) {
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
    coordinator.start()
    return (navigation, coordinator)
  }
  
  // MARK: - Build Popular Coordinator
  
  fileprivate func buildPopularCoordinator() -> (UIViewController, NCoordinator) {
    let coordinatorDependencies =
      PopularShowsDependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        imagesBaseURL: dependencies.appConfigurations.imagesBaseURL,
        showsPersistence: dependencies.showsPersistence)
    
    let navigation = UINavigationController()
    let coordinator = PopularCoordinator(navigationController: navigation,
                                         dependencies: coordinatorDependencies)
    
    let item = UITabBarItem(title: "Popular", image: UIImage(name: "popular"), tag: 1)
    coordinator.navigationController.tabBarItem = item
    coordinator.start()
    return (navigation, coordinator)
  }
}
