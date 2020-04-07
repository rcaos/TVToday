//
//  SearchFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

public class SearchFlow: Flow {
  
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
  
  private lazy var genresRepository: GenresRepository = {
    return DefaultGenreRepository(dataTransferService: apiDataTransferService)
  }()
  
  private lazy var showDetailsRepository: TVShowDetailsRepository = {
    return DefaultTVShowDetailsRepository(dataTransferService: apiDataTransferService)
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
    case SearchStep.searchFeatureInit:
      return navigateToSearchFeature()
      
    case SearchStep.genreIsPicked(let id):
      return navigateToGenreListScreen(with: id)
      
    case SearchStep.showIsPicked(let id):
      return navigateToShowDetailScreen(with: id)
      
    default:
      return .none
    }
  }
  
  fileprivate func navigateToSearchFeature() -> FlowContributors {
    let viewModel = SearchViewModel(
      fetchGenresUseCase: makeFetchGenresUseCase(),
      fetchTVShowsUseCase: makeShowListUseCase())
    let popularVC = SearchViewController.create(with: viewModel)
    
    rootViewController.pushViewController(popularVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: popularVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToGenreListScreen(with id: Int) -> FlowContributors {
    let viewModel = TVShowListViewModel(genreId: id, fetchTVShowsUseCase: makeShowListUseCase())
    let showList = TVShowListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(showList, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: showList, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let viewModel = TVShowDetailViewModel(id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase())
    let detailVC = TVShowDetailViewController.create(with: viewModel)
    
    rootViewController.pushViewController(detailVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailVC, withNextStepper: viewModel))
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchGenresUseCase() -> FetchGenresUseCase {
    return DefaultFetchGenresUseCase(genresRepository: genresRepository)
  }
  
  private func makeShowListUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
  
  private func makeFetchShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
     return DefaultFetchTVShowDetailsUseCase(tvShowDetailsRepository: showDetailsRepository)
   }
}

// MARK: - Steps

public enum SearchStep: Step {
  
  case
  
  searchFeatureInit,
  
  genreIsPicked(withId: Int),
  
  showIsPicked(withId: Int)
}
