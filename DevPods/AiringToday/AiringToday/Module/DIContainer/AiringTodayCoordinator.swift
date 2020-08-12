//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import ShowDetails
import Shared

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
    let tvDetailCoordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.detailShow] = tvDetailCoordinator
    
    let nextStep = ShowDetailsStep.showDetailsIsRequired(withId: showId)
    tvDetailCoordinator.start(with: nextStep)
  }
}

// MARK: - TVShowDetailCoordinatorDelegate

extension AiringTodayCoordinator: TVShowDetailCoordinatorDelegate {
  
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
