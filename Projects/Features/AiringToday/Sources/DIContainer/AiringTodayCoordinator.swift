//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared
import ShowDetailsInterface

class AiringTodayCoordinator: NavigationCoordinator, AiringTodayCoordinatorProtocol {

  public var navigationController: UINavigationController

  private let dependencies: AiringTodayCoordinatorDependencies

  private var childCoordinators = [AiringTodayChildCoordinator: NavigationCoordinator]()

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

  private func navigateToTodayFeature() {
    let airingTodayController = dependencies.buildAiringTodayViewController(coordinator: self)
    airingTodayController.navigationItem.title = "Today on TV"
    navigationController.pushViewController(airingTodayController, animated: true)
  }

  // MARK: - Navigate to Show Detail
  private func showDetailIsPicked(for showId: Int) {
    let tvDetailCoordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.detailShow] = tvDetailCoordinator

    let nextStep = ShowDetailsStep.showDetailsIsRequired(withId: showId)
    tvDetailCoordinator.navigate(to: nextStep)
  }
}

extension AiringTodayCoordinator: TVShowDetailCoordinatorDelegate {

  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
