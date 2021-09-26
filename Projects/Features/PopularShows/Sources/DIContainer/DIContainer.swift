//
//  DIContainer.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 7/20/20.
//

import UIKit
import Networking
import Shared

final class DIContainer {

  private let dependencies: ModuleDependencies

  // MARK: - Repositories
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()

  // MARK: - Initializer
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Module Coordinator
  func buildPopularCoordinator(navigationController: UINavigationController, delegate: PopularCoordinatorDelegate?) -> Coordinator {
    let coordinator = PopularCoordinator(navigationController: navigationController, dependencies: self)
    coordinator.delegate = delegate
    return coordinator
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
    let popularVC = PopularsViewController(viewModel: viewModel)
    return popularVC
  }
}
