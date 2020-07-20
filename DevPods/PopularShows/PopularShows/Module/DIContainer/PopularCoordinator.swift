//
//  PopularCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import ShowDetails
import Shared

protocol PopularCoordinatorDependencies {
  
  func buildPopularViewController(coordinator: PopularCoordinatorProtocol?) -> UIViewController
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController) -> TVShowDetailCoordinator
}

protocol PopularCoordinatorProtocol: class {
  
  func navigate(to step: PopularStep)
}

// MARK: - Default Implementation

class PopularCoordinator: NavigationCoordinator, PopularCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  private var childCoordinators = [PopularChildCoordinator: Coordinator]()
  
  private let dependencies: PopularCoordinatorDependencies
  
  // MARK: - Life Cycle
  
  init(navigationController: UINavigationController, dependencies: PopularCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  func start() {
    navigate(to: .popularFeatureInit)
  }
  
  // MARK: - Navigation
  
  func navigate(to step: PopularStep) {
    switch step {
    case .popularFeatureInit :
      return navigateToPopularFeature()
      
    case .showIsPicked(let id) :
      return navigateToShowDetailScreen(with: id)
    }
  }
  
  // MARK: - Default Step
  
  fileprivate func navigateToPopularFeature() {
    let popularController = dependencies.buildPopularViewController(coordinator: self)
    navigationController.pushViewController(popularController, animated: true)
  }
  
  // MARK: - Navigate to Show Detail
  
  fileprivate func navigateToShowDetailScreen(with showId: Int) {
    let tvDetailCoordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController)
    tvDetailCoordinator.delegate = self
    childCoordinators[.detailShow] = tvDetailCoordinator
    tvDetailCoordinator.start(with: .showDetailsIsRequired(withId: showId))
  }
}

// MARK: - TVShowDetailCoordinatorDelegate

extension PopularCoordinator: TVShowDetailCoordinatorDelegate {
  
  func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}

// MARK: - Steps

public enum PopularStep: Step {
  
  case popularFeatureInit,
  
  showIsPicked(Int)
}

// MARK: - ChildCoordinators

public enum PopularChildCoordinator {
  case detailShow
}
