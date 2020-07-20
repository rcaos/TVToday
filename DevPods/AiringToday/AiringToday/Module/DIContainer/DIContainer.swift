//
//  DIContainer.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 7/20/20.
//

import ShowDetails
import Shared

final class DIContainer {
  
  private let dependencies: ModuleDependencies
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
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
  
  func buildModuleCoordinator(navigationController: UINavigationController) -> Coordinator {
    return AiringTodayCoordinator(navigationController: navigationController, dependencies: self)
  }
  
  // MARK: - Uses Cases
  
  fileprivate func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchAiringTodayTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

// MARK: - AiringTodayCoordinatorDependencies

extension DIContainer: AiringTodayCoordinatorDependencies {
  
  func buildAiringTodayViewController(coordinator: AiringTodayCoordinatorProtocol?) -> UIViewController {
    let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase(),
                                         coordinator: coordinator)
    let todayVC = AiringTodayViewController.create(with: viewModel)
    return todayVC
  }
  
  // TODO, move to Another Module
  func buildTVShowDetailCoordinator(navigationController: UINavigationController) -> TVShowDetailCoordinator {
    return TVShowDetailCoordinator(navigationController: navigationController,
                                   dependencies: showDetailsDependencies)
  }
}
