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
  
  // Repositories
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var genresRepository: GenresRepository = {
    return DefaultGenreRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
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
  
  private func makeFetchGenresUseCase() -> FetchGenresUseCase {
    return DefaultFetchGenresUseCase(genresRepository: genresRepository)
  }
  
  private func makeShowListUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

// MARK: - Steps

public enum SearchStep: Step {
  
  case
  
  searchFeatureInit,
  
  genreIsPicked(withId: Int),
  
  showIsPicked(withId: Int)
}
