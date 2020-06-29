//
//  TVShowsListFlow.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import RxFlow
import Networking
import Shared
import ShowDetails

public class TVShowsListFlow: Flow {
  
  private let dependencies: ShowListDependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private var rootViewController: UINavigationController!
  
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
                                   imagesBaseURL: dependencies.imagesBaseURL)
  }()
  
  // MARK: - Life Cycle
  
  public init(rootViewController: UINavigationController, dependencies: ShowListDependencies) {
    self.rootViewController = rootViewController
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case TVShowListStep.genreList(let genreId):
      return navigateToGenreList(with: genreId)
      
    case TVShowListStep.watchList:
      return navigateToWatchList()
    
    case TVShowListStep.favoriteList:
      return navigateToFavorites()
      
    case TVShowListStep.showIsPicked(let showId):
      return navigateToShowDetailScreen(with: showId)
      
    default:
      return .none
    }
  }
  
  // MARK: - Navigate to Genre List
  
    fileprivate func navigateToGenreList(with id: Int) -> FlowContributors {
      let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeShowListByGenreUseCase(genreId: id))
      let showList = TVShowListViewController.create(with: viewModel)
  
      rootViewController.pushViewController(showList, animated: true)
  
  
      return .one(flowContributor: .contribute(
        withNextPresentable: showList, withNextStepper: viewModel))
    }
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() -> FlowContributors {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeFavoriteListUseCase())
    let showList = TVShowListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(showList, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: showList, withNextStepper: viewModel))
    //    return .none
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() -> FlowContributors {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeWatchListUseCase())
    let showList = TVShowListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(showList, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: showList, withNextStepper: viewModel))
    //    return .none
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
                                          dependencies: showDetailsDependencies)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailShowFlow,
      withNextStepper:
      OneStepper(withSingleStep:
        ShowDetailsStep.showDetailsIsRequired(withId: id))))
    
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

// MARK: - Steps

public enum TVShowListStep: Step {
  
  case
  
  genreList(genreId: Int),
  
  favoriteList,
  
  watchList,
  
  showIsPicked(showId: Int)
  
}
