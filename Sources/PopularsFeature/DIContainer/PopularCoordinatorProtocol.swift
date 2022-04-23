//
//  PopularCoordinatorProtocol.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsFeatureInterface

protocol PopularCoordinatorProtocol: AnyObject {
  func navigate(to step: PopularStep)
}

// MARK: - Coordinator Dependencies
protocol PopularCoordinatorDependencies {
  func buildPopularViewController(coordinator: PopularCoordinatorProtocol?) -> UIViewController

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol
}

// MARK: - Steps
public enum PopularStep: Step {
  case popularFeatureInit
  case showIsPicked(Int)
}

// MARK: - ChildCoordinators
public enum PopularChildCoordinator {
  case detailShow
}
