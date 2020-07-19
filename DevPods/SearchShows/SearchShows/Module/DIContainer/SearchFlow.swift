//
//  SearchFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow
import Networking
import ShowDetails
import TVShowsList
import Persistence
import Shared

public class SearchFlow: Flow {
  
  private let dependencies: SearchShowDependencies
  
  public var root: Presentable {
    return self.rootViewController
  }  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // MARK: - Repositories
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var genresRepository: GenresRepository = {
    return DefaultGenreRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var keychainRepository: KeychainRepository = {
    return DefaultKeychainRepository()
  }()
  
  // MARK: - Dependencies
  private lazy var showListDependencies: ShowListDependencies = {
    return ShowListDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                imagesBaseURL: dependencies.imagesBaseURL,
                                showsPersistence: dependencies.showsPersistence)
  }()
  
  private lazy var showDetailsDependencies: ShowDetailsDependencies = {
    return ShowDetailsDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                   imagesBaseURL: dependencies.imagesBaseURL,
                                   showsPersistenceRepository: dependencies.showsPersistence)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: SearchShowDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case SearchStep.searchFeatureInit:
      return navigateToSearchFeature()
      
    case SearchStep.genreIsPicked(let id, let title):
      return navigateToGenreListScreen(with: id, title: title)
      
    case SearchStep.showIsPicked(let showId):
      return navigateToShowDetailScreen(with: showId)
      
    default:
      return .none
    }
  }
  
  // MARK: - Main Search Screen
  
  fileprivate func navigateToSearchFeature() -> FlowContributors {
    let resultsSearchViewModel = buildResultsViewModel()
    
    let viewModel = SearchViewModel(resultsViewModel: resultsSearchViewModel)
    resultsSearchViewModel.delegate = viewModel
    
    let searchVC = SearchViewController.create(with: viewModel,
                                               searchController: buildSearchController(with: resultsSearchViewModel),
                                               searchOptionsViewController: buildSearchOptionsController(with: viewModel))
    
    rootViewController.pushViewController(searchVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: searchVC, withNextStepper: viewModel))
  }
  
  fileprivate func buildResultsViewModel() -> ResultsSearchViewModel {
    return ResultsSearchViewModel(fetchTVShowsUseCase: makeSearchShowsUseCase(),
                                  fetchRecentSearchsUseCase: makeFetchSearchsUseCase())
  }
  
  fileprivate func buildSearchController(with viewModel: ResultsSearchViewModel) -> UISearchController {
    let resultsController = ResultsSearchViewController(viewModel: viewModel)
    let searchController = UISearchController(searchResultsController: resultsController)
    return searchController
  }
  
  fileprivate func buildSearchOptionsController(with delegate: SearchOptionsViewModelDelegate) -> UIViewController {
    let viewModel = SearchOptionsViewModel(fetchGenresUseCase: makeFetchGenresUseCase(),
                                           fetchVisitedShowsUseCase: makeFetchVisitedShowsUseCase(),
                                           recentVisitedShowsDidChange: makeRecentShowsDidChangedUseCase())
    viewModel.delegate = delegate
    let viewController = SearchOptionsViewController.create(with: viewModel)
    return viewController
  }
  
  // MARK: - Navigate to List by Genre
  
  fileprivate func navigateToGenreListScreen(with id: Int, title: String?) -> FlowContributors {
    let listFlow = TVShowsListFlow(rootViewController: rootViewController,
                                   dependencies: showListDependencies)
    return .one(flowContributor: .contribute(
      withNextPresentable: listFlow,
      withNextStepper:
      OneStepper(withSingleStep: TVShowListStep.genreList(genreId: id, title: title) )))
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    return .none
//    let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
//                                          dependencies: showDetailsDependencies)
//    
//    return .one(flowContributor: .contribute(
//      withNextPresentable: detailShowFlow,
//      withNextStepper:
//      OneStepper(withSingleStep:
//        ShowDetailsStep.showDetailsIsRequired(withId: id))))
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchGenresUseCase() -> FetchGenresUseCase {
    return DefaultFetchGenresUseCase(genresRepository: genresRepository)
  }
  
  private func makeSearchShowsUseCase() -> SearchTVShowsUseCase {
    return DefaultSearchTVShowsUseCase(tvShowsRepository: showsRepository,
                                       keychainRepository: keychainRepository,
                                       searchsLocalRepository: dependencies.searchsPersistence)
  }
  
  private func makeFetchVisitedShowsUseCase() -> FetchVisitedShowsUseCase {
    return DefaultFetchVisitedShowsUseCase(
      showsVisitedLocalRepository: dependencies.showsPersistence,
      keychainRepository: keychainRepository)
  }
  
  private func makeFetchSearchsUseCase() -> FetchSearchsUseCase {
    return DefaultFetchSearchsUseCase(searchLocalRepository: dependencies.searchsPersistence,
                                      keychainRepository: keychainRepository)
  }
  
  private func makeRecentShowsDidChangedUseCase() -> RecentVisitedShowDidChangeUseCase {
    return DefaultRecentVisitedShowDidChangeUseCase(showsVisitedLocalRepository: dependencies.showsPersistence)
  }
}

// MARK: - Steps

public enum SearchStep: Step {
  
  case
  
  searchFeatureInit,
  
  genreIsPicked(withId: Int, title: String?),
  
  showIsPicked(withId: Int)
}
