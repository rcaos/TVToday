//
//  DIContainer.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 7/20/20.
//

import UIKit
import Shared
import ShowDetailsInterface

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
  func buildModuleCoordinator(navigationController: UINavigationController) -> Coordinator {
    let coordinator =  AiringTodayCoordinator(navigationController: navigationController, dependencies: self)
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

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return dependencies.showDetailsBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
