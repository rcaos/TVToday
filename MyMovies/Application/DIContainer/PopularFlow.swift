//
//  PopularFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

public class PopularFlow: Flow {
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let appConfigurations: AppConfigurations
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // Repositories
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.appConfigurations.imagesBaseURL)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case PopularStep.popularFeatureInit :
      return navigateToPopularFeature()
      
    case PopularStep.showIsPicked(let id) :
      return navigateToShowDetailScreen(with: id)
      
    default:
      return .none
    }
  }
  
  fileprivate func navigateToPopularFeature() -> FlowContributors {
    let viewModel = PopularViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase())
    let popularVC = PopularsViewController.create(with: viewModel)
    
    rootViewController.pushViewController(popularVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: popularVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
                                          dependencies: TVShowDetailFlow.Dependencies(
                                            apiDataTransferService: dependencies.apiDataTransferService,
                                            appConfigurations: dependencies.appConfigurations))
    
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

public enum PopularStep: Step {
  
  case
  
  popularFeatureInit,
  
  showIsPicked(withId: Int)
}
