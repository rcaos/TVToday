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
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // Dependencies, use struct instead ?
  private let apiDataTransferService: DataTransferService
  private let imageTransferService: DataTransferService
  
  // Repositories
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(dataTransferService: apiDataTransferService)
  }()
  
  // MARK: - Life Cycle
  
  public init(
    apiDataTransferService: DataTransferService,
    imageTransferService: DataTransferService) {
    self.apiDataTransferService = apiDataTransferService
    self.imageTransferService = imageTransferService
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case AiringTodayStep.todayFeatureInit:
      return navigateToTodayFeature()
      
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
  
  
  // MARK: - Uses Cases
  
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

// MARK: - Steps

public enum AiringTodayStep: Step {
  
  case
  
  todayFeatureInit
}
