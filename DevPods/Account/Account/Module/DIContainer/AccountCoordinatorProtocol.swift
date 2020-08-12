//
//  AccountCoordinatorProtocol.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/12/20.
//

import Shared
import ShowDetails
import TVShowsList

protocol AccountCoordinatorProtocol: class {
  
  func navigate(to step: AccountStep)
}

// MARK: - Coordinator Dependencies

protocol AccountCoordinatorDependencies {
  
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController
  
  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) -> UIViewController
  
  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinator
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
