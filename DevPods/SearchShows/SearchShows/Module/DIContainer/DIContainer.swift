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
  
  private lazy var showListDependencies: TVShowsList.ModuleDependencies = {
    return TVShowsList.ModuleDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                imagesBaseURL: dependencies.imagesBaseURL,
                                showsPersistence: dependencies.showsPersistence)
  }()
  
  private lazy var showDetailsDependencies: ShowDetails.ModuleDependencies = {
    return ShowDetails.ModuleDependencies(apiDataTransferService: dependencies.apiDataTransferService,
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
  
  fileprivate func buildResultsViewModel() -> ResultsSearchViewModelProtocol {
    return ResultsSearchViewModel(searchTVShowsUseCase: makeSearchShowsUseCase(),
                                  fetchRecentSearchsUseCase: makeFetchSearchsUseCase())
  }
  
  fileprivate func buildSearchController(with viewModel: ResultsSearchViewModelProtocol) -> UISearchController {
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
    var resultsSearchViewModel = buildResultsViewModel()
    let viewModel = SearchViewModel(resultsViewModel: resultsSearchViewModel,
                                    coordinator: coordinator)
    resultsSearchViewModel.delegate = viewModel
    let searchVC = SearchViewController.create(with: viewModel,
                                               searchController: buildSearchController(with: resultsSearchViewModel),
                                               searchOptionsViewController: buildSearchOptionsController(with: viewModel))
    return searchVC
  }
  
  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinator {
    let module = TVShowsList.Module(dependencies: showListDependencies)
    let coordinator = module.buildModuleCoordinator(in: navigationController, delegate: delegate)
    return coordinator
  }
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator {
    let module = ShowDetails.Module(dependencies: showDetailsDependencies)
    let coordinator = module.buildModuleCoordinator(in: navigationController, delegate: delegate)
    return coordinator
  }
}
