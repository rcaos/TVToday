//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking
import ShowDetails
import Shared

// MARK: - TODO:

public class AiringTodayCoordinator: FCoordinator {
  
  public var childCoordinators: [FCoordinator] = []
  
  public var parentCoordinator: FCoordinator?
  
  public var root: FPresentable {
    return self.rootViewController
  }
  
  public lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // MARK: - Dependencies
  
  private let dependencies: AiringTodayDependencies
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  // MARK: - Initializer
  
  public init(dependencies: AiringTodayDependencies) {
    self.dependencies = dependencies
  }
  
  public func start() {
    navigateToTodayFeature()
  }
  
  fileprivate func navigateToTodayFeature() {
    let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase())
    let todayVC = AiringTodayViewController.create(with: viewModel)
    
    rootViewController.pushViewController(todayVC, animated: true)
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchAiringTodayTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}


//private lazy var showDetailsDependencies: ShowDetailsDependencies = {
//   return ShowDetailsDependencies(apiDataTransferService: dependencies.apiDataTransferService,
//                                  imagesBaseURL: dependencies.imagesBaseURL,
//                                  showsPersistenceRepository: dependencies.showsPersistence)
// }()

//
//fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
//  let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
//                                        dependencies: showDetailsDependencies)
//
//  return .one(flowContributor: .contribute(
//    withNextPresentable: detailShowFlow,
//    withNextStepper:
//    OneStepper(withSingleStep:
//      ShowDetailsStep.showDetailsIsRequired(withId: id))))
//}

// MARK: - Navigation
//
//public func navigate(to step: Step) -> FlowContributors {
//  switch step {
//  case AiringTodayStep.todayFeatureInit:
//    return navigateToTodayFeature()
//
//  case AiringTodayStep.showIsPicked(let id):
//    return navigateToShowDetailScreen(with: id)
//
//  default:
//    return .none
//  }
//}

// MARK: - Steps
//
//public enum AiringTodayStep: Step {
//
//  case
//
//  todayFeatureInit,
//
//  showIsPicked(withId: Int)
//}
