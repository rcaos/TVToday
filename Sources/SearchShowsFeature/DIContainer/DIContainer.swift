//
//  DIContainer.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/20/20.
//


import Persistence
import Shared
import ShowDetailsFeatureInterface
import ShowListFeatureInterface
import UI
import UIKit

final class DIContainer {

  private let dependencies: ModuleDependencies

  // MARK: - Repositories
  private lazy var genresRepository: GenresRepository = {
    return DefaultGenreRepository(
      remoteDataSource: DefaultGenreRemoteDataSource(apiClient: dependencies.apiClient)
    )
  }()

  // MARK: - Long-Lived dependencies
  private let searchViewModel: SearchViewModel

  // MARK: - Initializer
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies

    searchViewModel = SearchViewModel()
  }

  // MARK: - Module Coordinator
  func buildModuleCoordinator(navigationController: UINavigationController) -> Coordinator {
    return SearchCoordinator(navigationController: navigationController, dependencies: self)
  }

  // MARK: - Search Feature Uses Cases
  private func makeSearchShowsUseCase() -> SearchTVShowsUseCase {
    let tvShowsPageRepository = DefaultTVShowsPageRepository(
      showsPageRemoteDataSource: DefaultTVShowsRemoteDataSource(apiClient: dependencies.apiClient),
      mapper: DefaultTVShowPageMapper(),
      imageBasePath: dependencies.imagesBaseURL
    )
    return DefaultSearchTVShowsUseCase(
      tvShowsPageRepository: tvShowsPageRepository,
      searchsLocalRepository: dependencies.searchsPersistence
    )
  }

  fileprivate func makeFetchSearchesUseCase() -> FetchSearchesUseCase {
    return DefaultFetchSearchesUseCase(searchLocalRepository: dependencies.searchsPersistence)
  }

  fileprivate func makeFetchGenresUseCase() -> FetchGenresUseCase {
    return DefaultFetchGenresUseCase(genresRepository: genresRepository)
  }

  fileprivate func makeFetchVisitedShowsUseCase() -> FetchVisitedShowsUseCase {
    return DefaultFetchVisitedShowsUseCase(showsVisitedLocalRepository: dependencies.showsPersistence)
  }

  fileprivate func makeRecentShowsDidChangedUseCase() -> RecentVisitedShowDidChangeUseCase {
    return DefaultRecentVisitedShowDidChangeUseCase(showsVisitedLocalRepository: dependencies.showsPersistence)
  }

  // MARK: - Search Feature View Models
  fileprivate func buildResultsViewModel(with delegate: ResultsSearchViewModelDelegate?) -> ResultsSearchViewModelProtocol {
    let resultsViewModel = ResultsSearchViewModel(searchTVShowsUseCase: makeSearchShowsUseCase(),
                                                  fetchRecentSearchesUseCase: makeFetchSearchesUseCase())
    resultsViewModel.delegate = searchViewModel
    return resultsViewModel
  }

  fileprivate func buildSearchController(with viewModel: ResultsSearchViewModelProtocol) -> UISearchController {
    let resultsController = ResultsSearchViewController(viewModel: viewModel)
    let searchController = UISearchController(searchResultsController: resultsController)
    return searchController
  }

  // MARK: - SearchViewControllerFactory
  func buildSearchOptionsController() -> UIViewController {
    let viewModel = SearchOptionsViewModel(
      fetchGenresUseCase: makeFetchGenresUseCase(),
      fetchVisitedShowsUseCase: { self.makeFetchVisitedShowsUseCase() },
      recentVisitedShowsDidChange: makeRecentShowsDidChangedUseCase()
    )
    viewModel.delegate = searchViewModel
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    return viewController
  }
}

// MARK: - SearchCoordinatorDependencies
extension DIContainer: SearchCoordinatorDependencies {

  func buildSearchViewController(coordinator: SearchCoordinatorProtocol?) -> UIViewController {
    let resultsViewModel = buildResultsViewModel(with: searchViewModel)

    searchViewModel.coordinator = coordinator
    searchViewModel.resultsViewModel = resultsViewModel

    let searchVC = SearchViewController(viewModel: searchViewModel,
                                        searchController: buildSearchController(with: resultsViewModel),
                                        searchControllerFactory: self)
    return searchVC
  }

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return dependencies.showDetailsBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }

  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    return dependencies.showListBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}

extension DIContainer: SearchViewControllerFactory { }
