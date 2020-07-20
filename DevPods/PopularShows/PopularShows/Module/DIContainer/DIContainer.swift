//
//  DIContainer.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 7/20/20.
//

import Networking
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
  
  // MARK: - Dependencies
  
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
  
  func buildPopularCoordinator(navigationController: UINavigationController) -> Coordinator {
    return PopularCoordinator(navigationController: navigationController, dependencies: self)
  }
  
  // MARK: - Uses Cases
  
  fileprivate func makeFetchPopularShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchPopularTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

extension DIContainer: PopularCoordinatorDependencies {
  
  func buildPopularViewController(coordinator: PopularCoordinatorProtocol?) -> UIViewController {
    let viewModel = PopularViewModel(fetchTVShowsUseCase: makeFetchPopularShowsUseCase(),
                                     coordinator: coordinator)
    let popularVC = PopularsViewController.create(with: viewModel)
    return popularVC
  }
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController) -> TVShowDetailCoordinator {
    return TVShowDetailCoordinator(navigationController: navigationController,
                                   dependencies: showDetailsDependencies)
  }
}
