//
//  DIContainer.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import ShowDetails
import Shared

final class DIContainer {
  
  private let dependencies: ModuleDependencies
  
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
  
  // MARK: - Initializer
  
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Module Coordinator
  
  func buildModuleCoordinator(navigationController: UINavigationController) -> TVShowListCoordinator {
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
  
  func buildShowDetailCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator {
    let module = ShowDetails.Module(dependencies: showDetailsDependencies)
    let coordinator = module.buildModuleCoordinator(in: navigationController, delegate: delegate)
    return coordinator
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

extension DIContainer: TVShowListCoordinatorDependencies { }
