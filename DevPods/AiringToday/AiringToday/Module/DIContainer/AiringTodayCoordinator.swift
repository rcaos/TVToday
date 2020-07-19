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

public protocol AiringTodayCoordinatorProtocol: class {
  
  func navigate(to step: AiringTodayStep)
}

public enum AiringTodayStep {
  
  case todayFeatureInit,
  
  showIsPicked(Int)
}

public enum AiringTodayChildCoordinator {
  case detailShow
}

public class AiringTodayCoordinator: NavigationCoordinator, AiringTodayCoordinatorProtocol {
  
  public var childCoordinators = [AiringTodayChildCoordinator: NCoordinator]()
  
  public var navigationController: UINavigationController
  
  // MARK: - Dependencies
  
  private let dependencies: AiringTodayDependencies
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var showDetailsDependencies: ShowDetailsDependencies = {
    return ShowDetailsDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                   imagesBaseURL: dependencies.imagesBaseURL,
                                   showsPersistenceRepository: dependencies.showsPersistence)
  }()
  
  // MARK: - Initializer
  
  public init(navigationController: UINavigationController, dependencies: AiringTodayDependencies) {
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
    let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase(),
                                         coordinator: self)
    let todayVC = AiringTodayViewController.create(with: viewModel)
    
    navigationController.pushViewController(todayVC, animated: true)
  }
  
  // MARK: - Navigate to Show Detail
  
  fileprivate func showDetailIsPicked(for showId: Int) {
    // TODO, dependencies should be in Struct with var?
    showDetailsDependencies.tvShowId = showId
    let tvDetailCoordinator = TVShowDetailCoordinator(navigationController: navigationController,
                                                      dependencies: showDetailsDependencies)
    childCoordinators[.detailShow] = tvDetailCoordinator
    tvDetailCoordinator.delegate = self
    tvDetailCoordinator.start()
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchAiringTodayTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

extension AiringTodayCoordinator: TVShowDetailCoordinatorDelegate {
  
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
