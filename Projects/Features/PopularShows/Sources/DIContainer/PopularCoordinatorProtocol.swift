//
//  PopularCoordinatorProtocol.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared

protocol PopularCoordinatorProtocol: class {
  func navigate(to step: PopularStep)
}

// MARK: - Coordinator Dependencies
protocol PopularCoordinatorDependencies {
  func buildPopularViewController(coordinator: PopularCoordinatorProtocol?) -> UIViewController
}

public protocol PopularCoordinatorDelegate {
  func tvShowDetailIsPicked(showId: Int, navigation: UINavigationController)
}

// MARK: - Steps
public enum PopularStep: Step {
  case popularFeatureInit
  case showIsPicked(Int)
}
