//
//  AccountCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking
import Shared
import TVShowsList

protocol AccountCoordinatorDependencies {
  
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController
  
  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) -> UIViewController
  
  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinator
}

protocol AccountCoordinatorProtocol: class {
  
  func navigate(to step: AccountStep)
}

class AccountCoordinator: NavigationCoordinator, AccountCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  private var childCoordinators = [AccountChildCoordinator: Coordinator]()
  
  private let dependencies: AccountCoordinatorDependencies
  
  // MARK: - Life Cycle
  
  init(navigationController: UINavigationController, dependencies: AccountCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start() {
    navigate(to: .accountFeatureInit)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: AccountStep) {
    switch step {
    case .accountFeatureInit:
      navigateToAccountFeature()
      
    case .signInIsPicked(let url, let delegate):
      navigateToAuthPermission(url: url, delegate: delegate)
      
    case .authorizationIsComplete:
      navigationController.presentedViewController?.dismiss(animated: true)
      
    case .favoritesIsPicked:
      navigateToFavorites()
      
    case .watchListIsPicked:
      navigateToWatchList()
    }
  }
  
  fileprivate func navigateToAccountFeature() {
    let accountVC = dependencies.buildAccountViewController(coordinator: self)
    navigationController.pushViewController(accountVC, animated: true)
  }
  
  fileprivate func navigateToAuthPermission(url: URL, delegate: AuthPermissionViewModelDelegate?) {
    let authViewController = dependencies.buildAuthPermissionViewController(url: url, delegate: delegate)
    let navController = UINavigationController(rootViewController: authViewController)
    navigationController.present(navController, animated: true)
  }
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() {
    let coordinator = dependencies.buildTVShowListCoordinator(navigationController: navigationController, delegate: self)
    coordinator.delegate = self
    childCoordinators[.tvShowList] = coordinator
    coordinator.start(with: .favoriteList)
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() {
    let coordinator = dependencies.buildTVShowListCoordinator(navigationController: navigationController, delegate: self)
    coordinator.delegate = self
    childCoordinators[.tvShowList] = coordinator
    coordinator.start(with: .watchList)
  }
}

// MARK: - TVShowListCoordinatorDelegate

extension AccountCoordinator: TVShowListCoordinatorDelegate {
  
  func tvShowListCoordinatorDidFinish() {
    childCoordinators[.tvShowList] = nil
  }
}

// MARK: - Steps

public enum AccountStep: Step {
  
  case
  
  accountFeatureInit,
  
  signInIsPicked(url: URL, delegate: AuthPermissionViewModelDelegate?),
  
  authorizationIsComplete,
  
  favoritesIsPicked,
  
  watchListIsPicked
}

// MARK: - Child Coordinators

public enum AccountChildCoordinator {
  case
  
  tvShowList
}
