//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

public class AiringTodayFlow: Flow {
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let imageTransferService: DataTransferService
    let apiDataTransferServiceReactive: DataTransferServiceReactive
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // MARK: - TODO, Repositories are be the Same??
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case AiringTodayStep.todayFeatureInit:
      return navigateToTodayFeature()
      
    case AiringTodayStep.showIsPicked(let id):
      return navigateToShowDetailScreen(with: id)
      
    default:
      return .none
    }
  }
  
  fileprivate func navigateToTodayFeature() -> FlowContributors {
    let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase())
    let todayVC = AiringTodayViewController.create(with: viewModel)
    
    rootViewController.pushViewController(todayVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: todayVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
      dependencies: TVShowDetailFlow.Dependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        imageTransferService: dependencies.imageTransferService,
        apiDataTransferServiceReactive: dependencies.apiDataTransferServiceReactive))
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailShowFlow,
      withNextStepper:
      OneStepper(withSingleStep:
        ShowDetailsStep.showDetailsIsRequired(withId: id))))
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

// MARK: - Steps

public enum AiringTodayStep: Step {
  
  case
  
  todayFeatureInit,
  
  showIsPicked(withId: Int)
}
