//
//  DIContainer.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 7/20/20.
//

import UIKit
import Shared

final class DIContainer {

  private let dependencies: ModuleDependencies

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
  func buildModuleCoordinator(navigationController: UINavigationController, delegate: AiringTodayCoordinatorDelegate?) -> Coordinator {
    let coordinator =  AiringTodayCoordinator(navigationController: navigationController, dependencies: self)
    coordinator.delegate = delegate
    return coordinator
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
}
