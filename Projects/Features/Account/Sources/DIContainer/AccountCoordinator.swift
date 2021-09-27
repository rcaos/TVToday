//
//  AccountCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared
import TVShowsListInterface

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
    
    let embedNavController = UINavigationController(rootViewController: authViewController)
    embedNavController.presentationController?.delegate = authViewController
    
    navigationController.present(embedNavController, animated: true)
  }
  
  // MARK: - Navigate to Favorites User
  fileprivate func navigateToFavorites() {
    let coordinator = dependencies.buildTVShowListCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.tvShowList] = coordinator
    coordinator.navigate(to: TVShowListStep.favoriteList)
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() {
    let coordinator = dependencies.buildTVShowListCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.tvShowList] = coordinator
    coordinator.navigate(to: TVShowListStep.watchList)
  }
}

// MARK: - TVShowListCoordinatorDelegate
extension AccountCoordinator: TVShowListCoordinatorDelegate {
  
  func tvShowListCoordinatorDidFinish() {
    childCoordinators[.tvShowList] = nil
  }
}
