//
//  Created by Jeans Ruiz on 20/04/22.
//

import Combine
import Persistence
import NetworkingInterface
import UIKit
import SearchShowsFeature
import Shared
import ShowDetailsFeatureInterface
import ShowListFeatureInterface

public class SearchShowsDemoCoordinator: Coordinator {
  private let window: UIWindow
  private let tabBarController: UITabBarController
  private let apiClient: ApiClient
  private let imagesBaseURL: String
  private var childCoordinators = [Coordinator]()

  public init(
    window: UIWindow,
    tabBarController: UITabBarController,
    apiClient: ApiClient,
    imagesBaseURL: String
  ) {
    self.window = window
    self.tabBarController = tabBarController
    self.apiClient = apiClient
    self.imagesBaseURL = imagesBaseURL
  }

  public func start() {
    showMainFeatures()
  }

  private func showMainFeatures() {
    let searchNavigation = UINavigationController()
    searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
    buildSearchScene(in: searchNavigation)

    tabBarController.setViewControllers([searchNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildSearchScene(in navigation: UINavigationController) {
    let dependencies = SearchShowsFeature.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: imagesBaseURL,
      showsPersistence: FakeShowsVisitedLocalRepository(),
      searchsPersistence: FakeSearchLocalRepository(),
      showDetailsBuilder: self,
      showListBuilder: self
    )
    let module = SearchShowsFeature.Module(dependencies: dependencies)
    let coordinator = module.buildSearchCoordinator(in: navigation)
    coordinator.start()
    childCoordinators.append(coordinator)
  }
}

extension SearchShowsDemoCoordinator: ModuleShowListDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    return EmptyListCoordinator(navigationController: navigationController)
  }
}

extension SearchShowsDemoCoordinator: ModuleShowDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return EmptyDetailCoordinator(navigationController: navigationController)
  }
}

// MARK: - TVShowDetailCoordinatorProtocol
class EmptyDetailCoordinator: TVShowDetailCoordinatorProtocol {
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func navigate(to step: ShowDetailsStep) {
    print("EmptyDetailCoordinator navigate to \(step)")
  }
}

// MARK: - TVShowListCoordinatorProtocol
class EmptyListCoordinator: TVShowListCoordinatorProtocol {
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func navigate(to step: TVShowListStep) {
    print("EmptyListCoordinator navigate to \(step)")
  }
}

// MARK: - SearchLocalRepository
final class FakeSearchLocalRepository: SearchLocalRepositoryProtocol {
  public func saveSearch(query: String) async throws { }

  public func fetchRecentSearches() async throws -> [Persistence.Search] {
    return []
  }
}
