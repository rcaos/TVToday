//
//  SignedCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared

public enum SignedChildCoordinator {
  case
  
  airingToday,
  
  popularShows,
  
  search,
  
  account
}

public class SignedCoordinator: Coordinator {
  
  private var tabBarController: UITabBarController
  
  private var childCoordinators = [SignedChildCoordinator: Coordinator]()
  
  private let appDIContainer: AppDIContainer
  
  // MARK: - Life Cycle
  
  public init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
    self.tabBarController = tabBarController
    self.appDIContainer = appDIContainer
  }
  
  public func start() {
    showMainFeatures()
  }
  
  fileprivate func showMainFeatures() {
    let todayScene = buildTodayScene()
    let popularScene = buildPopularScene()
    
    tabBarController.setViewControllers([todayScene, popularScene], animated: true)
    
//    childCoordinators[.airingToday] = todayCoordinator
//    childCoordinators[.popularShows] = popularCoordinator
//    childCoordinators[.search] = searchCoordinator
//    childCoordinators[.account] = accountCoordinator
  }
  
  // MARK: - Build Airing Today Scene
  
  fileprivate func buildTodayScene() -> UIViewController {
    let navigation = UINavigationController()
    
    let item = UITabBarItem(title: "Today", image: UIImage(name: "calendar"), tag: 0)
    navigation.tabBarItem = item
    
    let todayModule = appDIContainer.buildAiringTodayModule()
    let airingCoordinator = todayModule.buildAiringTodayCoordinator(in: navigation)
    airingCoordinator.start()
    childCoordinators[.airingToday] = airingCoordinator
    
    return navigation
  }
  
  // MARK: - Build Popular Scene
  
  fileprivate func buildPopularScene() -> UIViewController {
    let navigation = UINavigationController()
    
    let item = UITabBarItem(title: "Popular", image: UIImage(name: "popular"), tag: 1)
    navigation.tabBarItem = item
    
    let popularModule = appDIContainer.buildPopularModule()
    let popularCoordinator = popularModule.buildPopularCoordinator(in: navigation)
    
    popularCoordinator.start()
    childCoordinators[.popularShows] = popularCoordinator
    
    return navigation
  }
//
  // MARK: - Build Search Coordinator
  
//  fileprivate func buildSearchCoordinator() -> (UIViewController, Coordinator) {
//    let coordinatorDependencies =
//      SearchShowDependencies(
//      apiDataTransferService: dependencies.apiDataTransferService,
//      imagesBaseURL: dependencies.appConfigurations.imagesBaseURL,
//      showsPersistence: dependencies.showsPersistence,
//      searchsPersistence: dependencies.searchsPersistence)
//
//    let navigation = UINavigationController()
//    let coordinator = SearchCoordinator(navigationController: navigation,
//                                         dependencies: coordinatorDependencies)
//
//    let item = UITabBarItem(tabBarSystemItem: .search, tag: 2)
//    coordinator.navigationController.tabBarItem = item
//    coordinator.start()
//    return (navigation, coordinator)
//  }
  
  // MARK: - Build Account Coordinator
  
//  fileprivate func buildAccountCoordinator() -> (UIViewController, Coordinator) {
//    let coordinatorDependencies =
//      AccountDependencies(apiDataTransferService: dependencies.apiDataTransferService,
//      imagesBaseURL: dependencies.appConfigurations.imagesBaseURL,
//      showsPersistence: dependencies.showsPersistence)
//
//    let navigation = UINavigationController()
//    let coordinator = AccountCoordinator(navigationController: navigation,
//                                         dependencies: coordinatorDependencies)
//
//    let item = UITabBarItem(title: "Account", image: UIImage(name: "accountTab"), tag: 3)
//    coordinator.navigationController.tabBarItem = item
//    coordinator.start()
//    return (navigation, coordinator)
//  }
}
