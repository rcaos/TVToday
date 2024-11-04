//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsFeatureInterface
import ShowListFeatureInterface

final class DIContainer {
  private let dependencies: ShowListFeatureInterface.ModuleDependencies

  // MARK: - Repositories
  private lazy var accountShowsRepository: AccountTVShowsRepository = {
    return DefaultAccountTVShowsRepository(
      showsPageRemoteDataSource: AccountTVShowsRemoteDataSource(apiClient: dependencies.apiClient),
      mapper: DefaultTVShowPageMapper(),
      imageBasePath: dependencies.imagesBaseURL,
      loggedUserRepository: dependencies.loggedUserRepository
    )
  }()

  // MARK: - Initializer
  init(dependencies: ShowListFeatureInterface.ModuleDependencies) {
    self.dependencies = dependencies
  }

  // MARK: - Module Coordinator
  func buildModuleCoordinator(navigationController: UINavigationController,
                              delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    let coordinator =  TVShowListCoordinator(navigationController: navigationController, dependencies: self)
    coordinator.delegate = delegate
    return coordinator
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
    let showsPageRepository = DefaultTVShowsPageRepository(
      showsPageRemoteDataSource: DefaultTVShowsRemoteDataSource(apiClient: dependencies.apiClient),
      mapper: DefaultTVShowPageMapper(),
      imageBasePath: dependencies.imagesBaseURL
    )
    return DefaultFetchShowsByGenreTVShowsUseCase(
      genreId: genreId,
      tvShowsPageRepository: showsPageRepository
    )
  }

  private func makeWatchListUseCase() -> FetchTVShowsUseCase {
    return DefaultUserWatchListShowsUseCase(accountShowsRepository: accountShowsRepository)
  }

  private func makeFavoriteListUseCase() -> FetchTVShowsUseCase {
    return DefaultUserFavoritesShowsUseCase(accountShowsRepository: accountShowsRepository)
  }
}

// MARK: - TODO
extension DIContainer: TVShowListCoordinatorDependencies { }
