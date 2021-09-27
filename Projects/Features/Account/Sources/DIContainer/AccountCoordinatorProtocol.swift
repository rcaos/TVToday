//
//  AccountCoordinatorProtocol.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetails
import TVShowsListInterface

protocol AccountCoordinatorProtocol: AnyObject {
  func navigate(to step: AccountStep)
}

// MARK: - Coordinator Dependencies
protocol AccountCoordinatorDependencies {
  
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController
  
  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) -> AuthPermissionViewController
  
  func buildTVShowListCoordinator(navigationController: UINavigationController, delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol
}

// MARK: - Steps
public enum AccountStep: Step {
  case accountFeatureInit
  case signInIsPicked(url: URL, delegate: AuthPermissionViewModelDelegate?)
  case authorizationIsComplete
  case favoritesIsPicked
  case watchListIsPicked
}

// MARK: - Child Coordinators
public enum AccountChildCoordinator {
  case tvShowList
}
