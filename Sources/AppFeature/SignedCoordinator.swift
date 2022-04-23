//
//  SignedCoordinator.swift
//  AppFeature
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared

public enum SignedChildCoordinator {
  case airingToday
  case popularShows
  case search
  case account
}

public class SignedCoordinator: Coordinator {
  private let tabBarController: UITabBarController
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
    let todayNavigation = UINavigationController()
    todayNavigation.tabBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "calendar.badge.clock"), tag: 0)
    buildTodayScene(in: todayNavigation)

    let popularNavigation = UINavigationController()
    popularNavigation.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "star.fill"), tag: 1)
    buildPopularScene(in: popularNavigation)

    let searchNavigation = UINavigationController()
    searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
    buildSearchScene(in: searchNavigation)

    let accountNavigation = UINavigationController()
    accountNavigation.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle.fill"), tag: 3)
    buildAccountCoordinator(in: accountNavigation)

    tabBarController.setViewControllers([todayNavigation,
                                         popularNavigation,
                                         searchNavigation,
                                         accountNavigation], animated: true)
  }

  // MARK: - Build Airing Today Scene
  fileprivate func buildTodayScene(in navigation: UINavigationController) {
    let todayModule = appDIContainer.buildAiringTodayModule()
    let airingCoordinator = todayModule.buildAiringTodayCoordinator(in: navigation)
    airingCoordinator.start()
    childCoordinators[.airingToday] = airingCoordinator
  }

  // MARK: - Build Popular Scene
  fileprivate func buildPopularScene(in navigation: UINavigationController) {
    let popularModule = appDIContainer.buildPopularModule()
    let coordinator = popularModule.buildPopularCoordinator(in: navigation)
    coordinator.start()
    childCoordinators[.popularShows] = coordinator
  }

  // MARK: - Build Search Scene
  fileprivate func buildSearchScene(in navigation: UINavigationController) {
    let searchModule = appDIContainer.buildSearchModule()
    let coordinator = searchModule.buildSearchCoordinator(in: navigation)
    coordinator.start()
    childCoordinators[.search] = coordinator
  }

  // MARK: - Build Account Scene
  fileprivate func buildAccountCoordinator(in navigation: UINavigationController) {
    let accountModule = appDIContainer.buildAccountModule()
    let coordinator = accountModule.buildAccountCoordinator(in: navigation)
    coordinator.start()
    childCoordinators[.account] = coordinator
  }
}
