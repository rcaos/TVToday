//
//  Created by Jeans Ruiz on 21/04/22.
//

import NetworkingInterface
import UIKit
import Shared
import ShowDetailsFeatureInterface
import ShowListFeature
import ShowListFeatureInterface

public class ShowListDemoCoordinator: Coordinator {
  private let window: UIWindow
  private let tabBarController: UITabBarController
  private let apiClient: ApiClient
  private let imagesBaseURL: String
  private var childCoordinators = [Coordinator]()

  // MARK: - Life Cycle
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
    // MARK: - TODO, build ViewController with a button and navigate to Favorites and WhiteList
    let listNavigation = UINavigationController(rootViewController: UIViewController())
    buildListScene(in: listNavigation)

    tabBarController.setViewControllers([listNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildListScene(in navigation: UINavigationController) {
    let dependencies = ShowListFeatureInterface.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: imagesBaseURL,
      loggedUserRepository: FakeLoggedRepository(),
      showDetailsBuilder: self
    )
    let module = ShowListFeature.Module(dependencies: dependencies)
    let coordinator = module.buildModuleCoordinator(in: navigation, delegate: nil)
    //coordinator.navigate(to: .favoriteList) // Need a valid token
    // coordinator.navigate(to: .watchList) // Need a valid token
     coordinator.navigate(to: .genreList(genreId: 99, title: "Documentary"))
    childCoordinators.append(coordinator)
  }
}

extension ShowListDemoCoordinator: ModuleShowDetailsBuilder {
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

class FakeLoggedRepository: LoggedUserRepositoryProtocol {
  func saveUser(userId: Int, sessionId: String) { }

  func getUser() -> AccountDomain? {
    // rcaos account
    return AccountDomain(id: 8415942, sessionId: "405fb2545c73cf1ea9530776416615405327f2f7")
  }

  func deleteUser() { }
}
