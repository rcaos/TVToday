//
//  SignedCoordinator.swift
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
//    let (todayVC, todayCoordinator) = buildTodayCoordinator()
//    let (popularVC, popularCoordinator) = buildPopularCoordinator()
//    let (searchVC, searchCoordinator) = buildSearchCoordinator()
//    let (accountVC, accountCoordinator) = buildAccountCoordinator()
//
//    tabBarController.setViewControllers([todayVC, popularVC, searchVC, accountVC], animated: true)
  
    let todayScene = buildTodayScene()
    
    tabBarController.setViewControllers([todayScene], animated: true)
    
//    childCoordinators[.airingToday] = todayCoordinator
//    childCoordinators[.popularShows] = popularCoordinator
//    childCoordinators[.search] = searchCoordinator
//    childCoordinators[.account] = accountCoordinator
  }
  
  // MARK: - Build Airing Today Coordinator
  
  fileprivate func buildTodayScene() -> UIViewController {
    let navigation = UINavigationController()
    
    let item = UITabBarItem(title: "Today", image: UIImage(name: "calendar"), tag: 0)
    navigation.tabBarItem = item
    
    let todayModule = appDIContainer.makeAiringTodayModule()
    let airingCoordinator = todayModule.buildAiringTodayCoordinator(in: navigation)
    airingCoordinator.start()
    childCoordinators[.airingToday] = airingCoordinator
    
    return navigation
  }
  
  // MARK: - Build Popular Coordinator
  
//  fileprivate func buildPopularCoordinator() -> (UIViewController, Coordinator) {
//    let coordinatorDependencies =
//      PopularShowsDependencies(
//        apiDataTransferService: dependencies.apiDataTransferService,
//        imagesBaseURL: dependencies.appConfigurations.imagesBaseURL,
//        showsPersistence: dependencies.showsPersistence)
//
//    let navigation = UINavigationController()
//    let coordinator = PopularCoordinator(navigationController: navigation,
//                                         dependencies: coordinatorDependencies)
//
//    let item = UITabBarItem(title: "Popular", image: UIImage(name: "popular"), tag: 1)
//    coordinator.navigationController.tabBarItem = item
//    coordinator.start()
//    return (navigation, coordinator)
//  }
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
