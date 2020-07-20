//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Networking
import ShowDetails
import Shared

protocol AiringTodayCoordinatorDependencies {
  
  func buildAiringTodayViewController(coordinator: AiringTodayCoordinatorProtocol?) -> UIViewController
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController) -> TVShowDetailCoordinator
}

protocol AiringTodayCoordinatorProtocol: class {
  
  func navigate(to step: AiringTodayStep)
}

// MARK: - Default Implementation

class AiringTodayCoordinator: NavigationCoordinator, AiringTodayCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  private var childCoordinators = [AiringTodayChildCoordinator: Coordinator]()
  
  private let dependencies: AiringTodayCoordinatorDependencies
  
  // MARK: - Initializer
  
  public init(navigationController: UINavigationController,
              dependencies: AiringTodayCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start() {
    navigate(to: .todayFeatureInit)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: AiringTodayStep) {
    switch step {
    case .todayFeatureInit:
      navigateToTodayFeature()
      
    case .showIsPicked(let showId):
      showDetailIsPicked(for: showId)
    }
  }
  
  // MARK: - Default Step
  
  fileprivate func navigateToTodayFeature() {
    let airingTodayController = dependencies.buildAiringTodayViewController(coordinator: self)
    navigationController.pushViewController(airingTodayController, animated: true)
  }
  
  // MARK: - Navigate to Show Detail
  
  fileprivate func showDetailIsPicked(for showId: Int) {
    let tvDetailCoordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController)
    tvDetailCoordinator.delegate = self
    childCoordinators[.detailShow] = tvDetailCoordinator
    tvDetailCoordinator.start(with: .showDetailsIsRequired(withId: showId))
  }
}

// MARK: - TVShowDetailCoordinatorDelegate

extension AiringTodayCoordinator: TVShowDetailCoordinatorDelegate {
  
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}

// MARK: - Steps

public enum AiringTodayStep: Step {
  
  case todayFeatureInit,
  
  showIsPicked(Int)
}

// MARK: - ChildCoordinators

public enum AiringTodayChildCoordinator {
  case detailShow
}
