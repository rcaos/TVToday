//
//  PopularCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Networking
import ShowDetails
import Shared

public protocol PopularCoordinatorProtocol: class {
  
  func navigate(to step: PopularStep)
}

public class PopularCoordinator: NavigationCoordinator, PopularCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  private var childCoordinators = [PopularChildCoordinator: Coordinator]()
  
  // MARK: - Repositories
  
  private let dependencies: PopularShowsDependencies
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  // MARK: - Dependencies
  
  private lazy var showDetailsDependencies: ShowDetailsDependencies = {
    return ShowDetailsDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                   imagesBaseURL: dependencies.imagesBaseURL,
                                   showsPersistenceRepository: dependencies.showsPersistence)
  }()
  
  // MARK: - Life Cycle
  
  public init(navigationController: UINavigationController, dependencies: PopularShowsDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start() {
    navigate(to: .popularFeatureInit)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: PopularStep) {
    switch step {
    case .popularFeatureInit :
      return navigateToPopularFeature()
      
    case .showIsPicked(let id) :
      return navigateToShowDetailScreen(with: id)
    }
  }
  
  // MARK: - Default Step
  
  fileprivate func navigateToPopularFeature() {
    let viewModel = PopularViewModel(fetchTVShowsUseCase: makeFetchPopularShowsUseCase(), coordinator: self)
    let popularVC = PopularsViewController.create(with: viewModel)
    
    navigationController.pushViewController(popularVC, animated: true)
  }
  
  // MARK: - Navigate to Show Detail
  
  fileprivate func navigateToShowDetailScreen(with showId: Int) {
    let tvDetailCoordinator = TVShowDetailCoordinator(navigationController: navigationController,
                                                      dependencies: showDetailsDependencies)
    childCoordinators[.detailShow] = tvDetailCoordinator
    tvDetailCoordinator.delegate = self
    tvDetailCoordinator.start(with: .showDetailsIsRequired(withId: showId))
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchPopularShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchPopularTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

// MARK: - TVShowDetailCoordinatorDelegate

extension PopularCoordinator: TVShowDetailCoordinatorDelegate {
  
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
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
