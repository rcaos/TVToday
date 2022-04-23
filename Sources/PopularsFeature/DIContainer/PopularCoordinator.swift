//
//  PopularCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared
import ShowDetailsFeatureInterface

class PopularCoordinator: NavigationCoordinator, PopularCoordinatorProtocol {

  public var navigationController: UINavigationController

  private let dependencies: PopularCoordinatorDependencies

  private var childCoordinators = [PopularChildCoordinator: NavigationCoordinator]()

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
    popularController.navigationItem.title = "Popular TV Shows"
    navigationController.pushViewController(popularController, animated: true)
  }

  // MARK: - Navigate to Show Detail
  fileprivate func navigateToShowDetailScreen(with showId: Int) {
    let tvDetailCoordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.detailShow] = tvDetailCoordinator

    let nextStep = ShowDetailsStep.showDetailsIsRequired(withId: showId)
    tvDetailCoordinator.navigate(to: nextStep)
  }
}

extension PopularCoordinator: TVShowDetailCoordinatorDelegate {

  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
