//
//  AiringTodayCoordinatorProtocol.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared

protocol AiringTodayCoordinatorProtocol: class {
  func navigate(to step: AiringTodayStep)
}

// MARK: - Coordinator Dependencies
protocol AiringTodayCoordinatorDependencies {
  func buildAiringTodayViewController(coordinator: AiringTodayCoordinatorProtocol?) -> UIViewController
}

public protocol AiringTodayCoordinatorDelegate {
  func tvShowDetailIsPicked(showId: Int, navigation: UINavigationController)
}

// MARK: - Steps

public enum AiringTodayStep: Step {
  case todayFeatureInit
  case showIsPicked(Int)
}
