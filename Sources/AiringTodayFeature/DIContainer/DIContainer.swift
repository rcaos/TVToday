//
//  Created by Jeans Ruiz on 7/20/20.
//

import UIKit
import Shared
import ShowDetailsFeatureInterface

final class DIContainer {
  private let dependencies: ModuleDependencies

  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }

  func buildModuleCoordinator(navigationController: UINavigationController) -> Coordinator {
    let coordinator =  AiringTodayCoordinator(navigationController: navigationController, dependencies: self)
    return coordinator
  }

  // MARK: - Uses Cases
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    let showsPageRepository = DefaultTVShowsPageRepository(
      showsPageRemoteDataSource: DefaultTVShowsRemoteDataSource(
        apiClient: dependencies.apiClient
      ),
      mapper: DefaultTVShowPageMapper(),
      imageBasePath: dependencies.imagesBaseURL
    )
    return DefaultFetchAiringTodayTVShowsUseCase(tvShowsPageRepository: showsPageRepository)
  }
}

// MARK: - AiringTodayCoordinatorDependencies

extension DIContainer: AiringTodayCoordinatorDependencies {
  func buildAiringTodayViewController(coordinator: AiringTodayCoordinatorProtocol?) -> UIViewController {
    let viewModel = AiringTodayViewModel(
      fetchTVShowsUseCase: { self.makeFetchTodayShowsUseCase() },
      coordinator: coordinator
    )
    let todayVC = AiringTodayViewController(viewModel: viewModel)
    return todayVC
  }

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return dependencies.showDetailsBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
