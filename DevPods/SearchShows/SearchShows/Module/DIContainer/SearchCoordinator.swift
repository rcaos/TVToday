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

public protocol SearchCoordinatorProtocol: class {
  
  func navigate(to step: SearchStep)
}

public enum SearchStep: MyStep {
  
  case
  
  searchFeatureInit,
  
  genreIsPicked(withId: Int, title: String?),
  
  showIsPicked(withId: Int)
}

public enum SearchChildCoordinator {
  case
  
  detailShow,
  
  genreList
}

public class SearchCoordinator: NavigationCoordinator, SearchCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  private let dependencies: SearchShowDependencies
  
  private var childCoordinators = [SearchChildCoordinator: NCoordinator]()
  
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
  
  public init(navigationController: UINavigationController, dependencies: SearchShowDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public func start() {
    navigate(to: .searchFeatureInit)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: SearchStep) {
    switch step {
    case .searchFeatureInit:
      navigateToSearchFeature()
      
    case .genreIsPicked(let id, let title):
      navigateToGenreListScreen(with: id, title: title)
      
    case .showIsPicked(let showId):
      navigateToShowDetailScreen(with: showId)
    }
  }
  
  // MARK: - Main Search Screen
  
  fileprivate func navigateToSearchFeature() {
    let resultsSearchViewModel = buildResultsViewModel()
    
    let viewModel = SearchViewModel(resultsViewModel: resultsSearchViewModel,
                                    coordinator: self)
    resultsSearchViewModel.delegate = viewModel
    
    let searchVC = SearchViewController.create(with: viewModel,
                                               searchController: buildSearchController(with: resultsSearchViewModel),
                                               searchOptionsViewController: buildSearchOptionsController(with: viewModel))
    
    navigationController.pushViewController(searchVC, animated: true)
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
  
  fileprivate func navigateToGenreListScreen(with id: Int, title: String?) {
    let coordinator = TVShowListCoordinator(navigationController: navigationController, dependencies: showListDependencies)
    coordinator.delegate = self
    childCoordinators[.genreList] = coordinator
    coordinator.start(with: .genreList(genreId: id, title: title))
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int) {
    
    let coordinator = TVShowDetailCoordinator(navigationController: navigationController, dependencies: showDetailsDependencies)
    coordinator.delegate = self
    childCoordinators[.detailShow] = coordinator
    coordinator.start(with: .showDetailsIsRequired(withId: id))
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

// MARK: - TVShowListCoordinatorDelegate

extension SearchCoordinator: TVShowListCoordinatorDelegate {
  
  public func tvShowListCoordinatorDidFinish() {
    childCoordinators[.genreList] = nil
  }
}

// MARK: - TVShowDetailCoordinatorDelegate

extension SearchCoordinator: TVShowDetailCoordinatorDelegate {
  
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
