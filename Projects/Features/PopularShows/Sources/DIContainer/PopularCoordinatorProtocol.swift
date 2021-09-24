//
//  PopularCoordinatorProtocol.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetails

protocol PopularCoordinatorProtocol: class {
  
  func navigate(to step: PopularStep)
}

// MARK: - Coordinator Dependencies

protocol PopularCoordinatorDependencies {
  
  func buildPopularViewController(coordinator: PopularCoordinatorProtocol?) -> UIViewController
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator
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
