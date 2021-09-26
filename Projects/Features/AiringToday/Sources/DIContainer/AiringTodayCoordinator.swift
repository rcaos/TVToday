//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared

class AiringTodayCoordinator: NavigationCoordinator, AiringTodayCoordinatorProtocol {

  public var navigationController: UINavigationController

  private let dependencies: AiringTodayCoordinatorDependencies

  public var delegate: AiringTodayCoordinatorDelegate?

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
    airingTodayController.navigationItem.title = "Today on TV"
    navigationController.pushViewController(airingTodayController, animated: true)
  }
  
  // MARK: - Navigate to Show Detail
  
  fileprivate func showDetailIsPicked(for showId: Int) {
    delegate?.tvShowDetailIsPicked(showId: showId, navigation: navigationController)
  }
}
