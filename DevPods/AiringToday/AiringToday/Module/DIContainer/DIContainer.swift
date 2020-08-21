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
    let todayVC = AiringTodayViewController(viewModel: viewModel)
    return todayVC
  }
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator {
    
    let module = ShowDetails.Module(dependencies: showDetailsDependencies)
    let coordinator = module.buildModuleCoordinator(in: navigationController, delegate: delegate)
    return coordinator
  }
}
