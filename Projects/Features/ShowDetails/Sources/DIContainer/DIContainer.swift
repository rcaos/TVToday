//
//  DIContainer.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared

final class DIContainer {
  
  private let dependencies: ModuleDependencies
  
  // MARK: - Repositories
  
  private lazy var tvShowsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var accountShowsRepository: AccountTVShowsRepository = {
    return DefaultAccountTVShowsRepository(dataTransferService: dependencies.apiDataTransferService,
                                           basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var keychainRepository: KeychainRepository = {
    return DefaultKeychainRepository()
  }()
  
  private lazy var episodesRepository: TVEpisodesRepository = {
    return DefaultTVEpisodesRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  // MARK: - Initializer
  
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Module Coordinator
   
  func buildModuleCoordinator(navigationController: UINavigationController, delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator {
    let coordinator = TVShowDetailCoordinator(navigationController: navigationController, dependencies: self)
    coordinator.delegate = delegate
    return coordinator
  }
  
  // MARK: - Build View Controllers
  
  func buildShowDetailsViewController(with showId: Int,
                                      coordinator: TVShowDetailCoordinatorProtocol?,
                                      closures: TVShowDetailViewModelClosures? = nil) -> UIViewController {
    let viewModel = TVShowDetailViewModel(showId,
                                          fetchLoggedUser: makeFetchLoggedUserUseCase(),
                                          fetchDetailShowUseCase: makeFetchShowDetailsUseCase(),
                                          fetchTvShowState: makeTVAccountStatesUseCase(),
                                          markAsFavoriteUseCase: makeMarkAsFavoriteUseCase(),
                                          saveToWatchListUseCase: makeSaveToWatchListUseCase(),
                                          coordinator: coordinator,
                                          closures: closures)
    let detailVC = TVShowDetailViewController(viewModel: viewModel)
    return detailVC
  }
  
  func buildEpisodesViewController(with showId: Int) -> UIViewController {
    let viewModel = EpisodesListViewModel(
      tvShowId: showId,
      fetchDetailShowUseCase: makeFetchShowDetailsUseCase(),
      fetchEpisodesUseCase: makeFetchEpisodesUseCase())
    
    let seasonsVC = EpisodesListViewController(viewModel: viewModel)
    
    return seasonsVC
  }
  
  // MARK: - Uses Cases for Show Details
  
  private func makeFetchShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
    return DefaultFetchTVShowDetailsUseCase(tvShowsRepository: tvShowsRepository,
                                            keychainRepository: keychainRepository,
                                            tvShowsVisitedRepository: dependencies.showsPersistenceRepository)
  }
  
  private func makeMarkAsFavoriteUseCase() -> MarkAsFavoriteUseCase {
    return DefaultMarkAsFavoriteUseCase(accountShowsRepository: accountShowsRepository,
                                        keychainRepository: keychainRepository)
  }
  
  private func makeSaveToWatchListUseCase() -> SaveToWatchListUseCase {
    return DefaultSaveToWatchListUseCase(accountShowsRepository: accountShowsRepository,
                                         keychainRepository: keychainRepository)
  }
  
  private func makeTVAccountStatesUseCase() -> FetchTVAccountStates {
    return DefaultFetchTVAccountStates(accountShowsRepository: accountShowsRepository,
                                       keychainRepository: keychainRepository)
  }
  
  private func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
    return DefaultFetchLoggedUser(keychainRepository: keychainRepository)
  }
  
  // MARK: - Uses Cases for Seasons
  
  private func makeFetchEpisodesUseCase() -> FetchEpisodesUseCase {
    return DefaultFetchEpisodesUseCase(episodesRepository: episodesRepository)
  }
}

extension DIContainer: TVShowDetailCoordinatorDependencies {
  
}
