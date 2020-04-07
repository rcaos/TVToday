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
  
  private lazy var showDetailsRepository: TVShowDetailsRepository = {
    return DefaultTVShowDetailsRepository(dataTransferService: apiDataTransferService)
  }()
  
  private lazy var episodesRepository: TVEpisodesRepository = {
    return DefaultTVEpisodesRepository(dataTransferService: apiDataTransferService)
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
    case PopularStep.popularFeatureInit :
      return navigateToPopularFeature()
      
    case PopularStep.showIsPicked(let id) :
      return navigateToShowDetailScreen(with: id)
      
    case ShowDetailsStep.seasonsAreRequired(let showId):
      return navigateToSeasonsScreen(with: showId)
      
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
    let viewModel = TVShowDetailViewModel(id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase())
    let detailVC = TVShowDetailViewController.create(with: viewModel)
    
    rootViewController.pushViewController(detailVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToSeasonsScreen(with id: Int) -> FlowContributors {
    let viewModel = EpisodesListViewModel(tvShowId: id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase(), fetchEpisodesUseCase: makeFetchEpisodesUseCase())
    let seasonsVC = EpisodesListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(seasonsVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: seasonsVC, withNextStepper: viewModel))
  }
  
  
  // MARK: - Uses Cases
  
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
  
  private func makeFetchShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
    return DefaultFetchTVShowDetailsUseCase(tvShowDetailsRepository: showDetailsRepository)
  }
  
  private func makeFetchEpisodesUseCase() -> FetchEpisodesUseCase {
     return DefaultFetchEpisodesUseCase(episodesRepository: episodesRepository)
   }
}

// MARK: - Steps

public enum PopularStep: Step {
  
  case
  
  popularFeatureInit,
  
  showIsPicked(withId: Int)
}
