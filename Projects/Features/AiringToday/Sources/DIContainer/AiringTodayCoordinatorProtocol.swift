//
//  AiringTodayCoordinatorProtocol.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsInterface

protocol AiringTodayCoordinatorProtocol: class {
  func navigate(to step: AiringTodayStep)
}

// MARK: - Coordinator Dependencies
protocol AiringTodayCoordinatorDependencies {
  func buildAiringTodayViewController(coordinator: AiringTodayCoordinatorProtocol?) -> UIViewController

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol
}

// MARK: - Steps
public enum AiringTodayStep: Step {
  case todayFeatureInit
  case showIsPicked(Int)
}

// MARK: - ChildCoordinators
public enum AiringTodayChildCoordinator {
  case detailShow
}
