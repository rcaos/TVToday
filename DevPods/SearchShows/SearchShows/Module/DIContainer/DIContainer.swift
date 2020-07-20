//
//  DIContainer.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/20/20.
//

import Shared
import Persistence
import TVShowsList
import ShowDetails

final class DIContainer {
  
  private let dependencies: ModuleDependencies
  
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
  
  // MARK: - Initializer
  
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Module Coordinator
  
  func buildModuleCoordinator(navigationController: UINavigationController) -> Coordinator {
    return SearchCoordinator(navigationController: navigationController, dependencies: self)
  }
  
  // MARK: - Search Feature Uses Cases
  
  fileprivate func makeSearchShowsUseCase() -> SearchTVShowsUseCase {
    return DefaultSearchTVShowsUseCase(tvShowsRepository: showsRepository,
                                       keychainRepository: keychainRepository,
                                       searchsLocalRepository: dependencies.searchsPersistence)
  }
  
  fileprivate func makeFetchSearchsUseCase() -> FetchSearchsUseCase {
    return DefaultFetchSearchsUseCase(searchLocalRepository: dependencies.searchsPersistence,
                                      keychainRepository: keychainRepository)
  }
  
  private func makeFetchGenresUseCase() -> FetchGenresUseCase {
    return DefaultFetchGenresUseCase(genresRepository: genresRepository)
  }
  
  private func makeFetchVisitedShowsUseCase() -> FetchVisitedShowsUseCase {
    return DefaultFetchVisitedShowsUseCase(
      showsVisitedLocalRepository: dependencies.showsPersistence,
      keychainRepository: keychainRepository)
  }
  
  private func makeRecentShowsDidChangedUseCase() -> RecentVisitedShowDidChangeUseCase {
    return DefaultRecentVisitedShowDidChangeUseCase(showsVisitedLocalRepository: dependencies.showsPersistence)
  }
  
  // MARK: - Search Feature View Models
  
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
}

// MARK: - SearchCoordinatorDependencies

extension DIContainer: SearchCoordinatorDependencies {
  
  func buildSearchViewController(coordinator: SearchCoordinatorProtocol?) -> UIViewController {
    let resultsSearchViewModel = buildResultsViewModel()
    let viewModel = SearchViewModel(resultsViewModel: resultsSearchViewModel,
                                    coordinator: coordinator)
    resultsSearchViewModel.delegate = viewModel
    let searchVC = SearchViewController.create(with: viewModel,
                                               searchController: buildSearchController(with: resultsSearchViewModel),
                                               searchOptionsViewController: buildSearchOptionsController(with: viewModel))
    return searchVC
  }
  
  func buildTVShowListCoordinator(navigationController: UINavigationController) -> TVShowListCoordinator {
    return TVShowListCoordinator(navigationController: navigationController, dependencies: showListDependencies)
  }
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController) -> TVShowDetailCoordinator {
    return TVShowDetailCoordinator(navigationController: navigationController, dependencies: showDetailsDependencies)
  }
}
