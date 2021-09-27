//
//  DIContainer.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsInterface
import TVShowsListInterface

final class DIContainer {
  
  private let dependencies: TVShowsListInterface.ModuleDependencies
  
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

  // MARK: - Initializer
  init(dependencies: TVShowsListInterface.ModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Module Coordinator
  func buildModuleCoordinator(navigationController: UINavigationController, delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    return TVShowListCoordinator(navigationController: navigationController, dependencies: self)
  }
  
  // MARK: - Build View Controllers
  func buildShowListViewController_ForGenres(with genreId: Int,
                                             coordinator: TVShowListCoordinatorProtocol,
                                             stepOrigin: TVShowListStepOrigin? = nil) -> UIViewController {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeShowListByGenreUseCase(genreId: genreId),
                                        coordinator: coordinator)
    let showListVC = TVShowListViewController(viewModel: viewModel)
    return showListVC
  }
  
  func buildShowListViewController_ForFavorites(coordinator: TVShowListCoordinatorProtocol, stepOrigin: TVShowListStepOrigin?) -> UIViewController {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeFavoriteListUseCase(),
                                        coordinator: coordinator, stepOrigin: stepOrigin)
    let showListVC = TVShowListViewController(viewModel: viewModel)
    return showListVC
  }
  
  func buildShowListViewController_ForWatchList(coordinator: TVShowListCoordinatorProtocol, stepOrigin: TVShowListStepOrigin?) -> UIViewController {
    let viewModel = TVShowListViewModel(fetchTVShowsUseCase: makeWatchListUseCase(),
                                        coordinator: coordinator, stepOrigin: stepOrigin)
    let showListVC = TVShowListViewController(viewModel: viewModel)
    return showListVC
  }

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return dependencies.showDetailsBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
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

// MARK: - TODO
extension DIContainer: TVShowListCoordinatorDependencies { }
