//
//  DIContainer.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsFeatureInterface

final class DIContainer {

  private let dependencies: ModuleDependencies

  // MARK: - Repositories
  private lazy var accountShowsRepository: AccountTVShowsDetailsRepository = {
    return DefaultAccountTVShowsDetailsRepository(
      showsPageRemoteDataSource: DefaultTVShowsRemoteDataSource(dataTransferService: dependencies.apiDataTransferService),
      mapper: DefaultAccountTVShowDetailsMapper(),
      loggedUserRepository: dependencies.loggedUserRepository
    )
  }()

  private lazy var episodesRepository: TVEpisodesRepository = {
    return DefaultTVEpisodesRepository(
      remoteDataSource: DefaultTVEpisodesRemoteDataSource(dataTransferService: dependencies.apiDataTransferService),
      mapper: TVEpisodesMapper(),
      imageBasePath: dependencies.imagesBaseURL
    )
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
    let tvShowDetailsRepository = DefaultTVShowsDetailRepository(
      showsPageRemoteDataSource: DefaultTVShowsRemoteDataSource(dataTransferService: dependencies.apiDataTransferService),
      mapper: DefaultTVShowDetailsMapper(),
      imageBasePath: dependencies.imagesBaseURL
    )
    return DefaultFetchTVShowDetailsUseCase(
      tvShowDetailsRepository: tvShowDetailsRepository,
      tvShowsVisitedRepository: dependencies.showsPersistenceRepository
    )
  }

  private func makeMarkAsFavoriteUseCase() -> MarkAsFavoriteUseCase {
    return DefaultMarkAsFavoriteUseCase(accountShowsRepository: accountShowsRepository)
  }

  private func makeSaveToWatchListUseCase() -> SaveToWatchListUseCase {
    return DefaultSaveToWatchListUseCase(accountShowsRepository: accountShowsRepository)
  }

  private func makeTVAccountStatesUseCase() -> FetchTVAccountStates {
    return DefaultFetchTVAccountStates(accountShowsRepository: accountShowsRepository)
  }

  private func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
    return DefaultFetchLoggedUser(loggedRepository: dependencies.loggedUserRepository)
  }

  // MARK: - Uses Cases for Seasons
  private func makeFetchEpisodesUseCase() -> FetchEpisodesUseCase {
    return DefaultFetchEpisodesUseCase(episodesRepository: episodesRepository)
  }
}

extension DIContainer: TVShowDetailCoordinatorDependencies {

}
