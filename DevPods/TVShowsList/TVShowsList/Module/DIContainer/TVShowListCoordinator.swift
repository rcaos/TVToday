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
  
   // MARK: TODO, refactor dependencies
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
  
  private lazy var showDetailsDependencies: ShowDetails.ModuleDependencies = {
    return ShowDetails.ModuleDependencies(apiDataTransferService: dependencies.apiDataTransferService,
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
      
    case .showIsPicked(let showId, let stepOrigin, let closure):
        navigateToShowDetailScreen(with: showId, stepOrigin: stepOrigin, closure: closure)
      
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
                                        coordinator: self, stepOrigin: .favoriteList)
    let showList = TVShowListViewController.create(with: viewModel)
    showList.title = "Favorites"
    navigationController.pushViewController(showList, animated: true)
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeWatchListUseCase(),
                                        coordinator: self, stepOrigin: .watchList)
    let showList = TVShowListViewController.create(with: viewModel)
    showList.title = "Watch List"
    navigationController.pushViewController(showList, animated: true)
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int,
                                              stepOrigin: TVShowListStepOrigin?,
                                              closure: ((_ updated: TVShowUpdated) -> Void)? ) {
    let closures = makeClosures(with: stepOrigin, closure: closure)
  
    let module = ShowDetails.Module(dependencies: showDetailsDependencies)
    
    let tvDetailCoordinator = module.buildModuleCoordinator(in: navigationController, delegate: self)
    childCoordinators[.detailShow] = tvDetailCoordinator
    
    let detailStep = ShowDetailsStep.showDetailsIsRequired(withId: id, closures: closures)
    tvDetailCoordinator.start(with: detailStep)
  }
  
  fileprivate func makeClosures(with stepOrigin: TVShowListStepOrigin?, closure: ((_ updated: TVShowUpdated) -> Void)? ) -> TVShowDetailViewModelClosures?{
    switch stepOrigin {
    case .favoriteList:
      return TVShowDetailViewModelClosures(updateFavoritesShows: closure)
    case .watchList:
      return TVShowDetailViewModelClosures(updateWatchListShows: closure)
    default:
      return nil
    }
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
  
  showIsPicked(showId: Int,
    stepOrigin: TVShowListStepOrigin?,
    closure: (_ updated: TVShowUpdated) -> Void),
  
  showListDidFinish
}

// MARK: - ChildCoordinators

public enum TVShowListChildCoordinator {
  case detailShow
}

// MARK: - Steps Origin

public enum TVShowListStepOrigin {
  case
  
  favoriteList ,
  
  watchList
}
