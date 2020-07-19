//
//  TVShowListCoordinator.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Networking
import Shared
import ShowDetails

public protocol TVShowListCoordinatorProtocol: class {
  
  func navigate(to step: TVShowListStep)
}

public protocol TVShowListCoordinatorDelegate: class {
  
  func tvShowListCoordinatorDidFinish()
}

// MARK: - Default Implementation

public class TVShowListCoordinator: NavigationCoordinator, TVShowListCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  public weak var delegate: TVShowListCoordinatorDelegate?
  
  private let dependencies: ShowListDependencies
  
  private var childCoordinators = [TVShowListChildCoordinator: Coordinator]()
  
  // MARK: - Repositories
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var accountShowsRepository: AccountTVShowsRepository = {
    return DefaultAccountTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var keychainRepository: KeychainRepository = {
    return DefaultKeychainRepository()
  }()
  
  // MARK: - Dependencies
  
  private lazy var showDetailsDependencies: ShowDetailsDependencies = {
    return ShowDetailsDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                   imagesBaseURL: dependencies.imagesBaseURL,
                                   showsPersistenceRepository: dependencies.showsPersistence)
  }()
  
  // MARK: - Life Cycle
  
  public init(navigationController: UINavigationController, dependencies: ShowListDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start(with step: TVShowListStep) {
    navigate(to: step)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: TVShowListStep) {
    switch step {
    case .genreList(let genreId, let title):
      navigateToGenreList(with: genreId, title: title)
      
    case .watchList:
      navigateToWatchList()
      
    case .favoriteList:
      navigateToFavorites()
      
    case .showIsPicked(let showId):
      navigateToShowDetailScreen(with: showId)
      
    case .showListDidFinish:
      delegate?.tvShowListCoordinatorDidFinish()
    }
  }
  
  // MARK: - Navigate to Genre List
  
  fileprivate func navigateToGenreList(with id: Int, title: String?) {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeShowListByGenreUseCase(genreId: id),
                                        coordinator: self)
    let showList = TVShowListViewController.create(with: viewModel)
    showList.title = title
    navigationController.pushViewController(showList, animated: true)
  }
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeFavoriteListUseCase(),
                                        coordinator: self)
    let showList = TVShowListViewController.create(with: viewModel)
    showList.title = "Favorites"
    navigationController.pushViewController(showList, animated: true)
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeWatchListUseCase(),
                                        coordinator: self)
    let showList = TVShowListViewController.create(with: viewModel)
    showList.title = "Watch List"
    navigationController.pushViewController(showList, animated: true)
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int) {
  
    let tvDetailCoordinator = TVShowDetailCoordinator(navigationController: navigationController, dependencies: showDetailsDependencies)
    
    childCoordinators[.detailShow] = tvDetailCoordinator
    tvDetailCoordinator.delegate = self
    tvDetailCoordinator.start(with: .showDetailsIsRequired(withId: id))
  }
  
  // MARK: - Build Uses Cases
  
  private func makeShowListByGenreUseCase(genreId: Int) -> FetchTVShowsUseCase {
    return DefaultFetchShowsByGenreTVShowsUseCase(genreId: genreId,
                                                  tvShowsRepository: showsRepository)
  }
  
  private func makeWatchListUseCase() -> FetchTVShowsUseCase {
    return DefaultUserWatchListShowsUseCase(accountShowsRepository: accountShowsRepository,
                                            keychainRepository: keychainRepository)
  }
  
  private func makeFavoriteListUseCase() -> FetchTVShowsUseCase {
    return DefaultUserFavoritesShowsUseCase(accountShowsRepository: accountShowsRepository,
                                            keychainRepository: keychainRepository)
  }
}

// MARK: - TVShowDetailCoordinatorDelegate

extension TVShowListCoordinator: TVShowDetailCoordinatorDelegate {
  
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}

// MARK: - Steps

public enum TVShowListStep: Step {
  
  case
  
  genreList(genreId: Int, title: String?),
  
  favoriteList,
  
  watchList,
  
  showIsPicked(showId: Int),
  
  showListDidFinish
}

// MARK: - ChildCoordinators

public enum TVShowListChildCoordinator {
  case detailShow
}
