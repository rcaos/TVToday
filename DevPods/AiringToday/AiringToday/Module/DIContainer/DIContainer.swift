//
//  DIContainer.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 7/20/20.
//

import Foundation
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
  
  // MARK: - Uses Cases
   
   private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
     return DefaultFetchAiringTodayTVShowsUseCase(tvShowsRepository: showsRepository)
   }
  
  // MARK: - Airing Today List
  
  public func makeAiringTodayViewController(coordinator: AiringTodayCoordinatorProtocol?) -> UIViewController {
    let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase(),
                                         coordinator: coordinator)
    let todayVC = AiringTodayViewController.create(with: viewModel)
    return todayVC
  }
  
  // MARK: - Show Detail Coordinator
  
  // TODO, move to Another Module
  public func makeTVShowDetailCoordinator(navigationController: UINavigationController) -> TVShowDetailCoordinator {
    return TVShowDetailCoordinator(navigationController: navigationController,
                                   dependencies: showDetailsDependencies)
  }
  
  // MARK: - Module Coordinator
  
  public func makeAiringTodayCoordinator(navigationController: UINavigationController) -> Coordinator {
    return AiringTodayCoordinator(navigationController: navigationController, dependencies: self)
  }
}

extension DIContainer: AiringTodayCoordinatorDependencies {
  
}
