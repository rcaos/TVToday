//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 20/04/22.
//

import Combine
import Persistence
import NetworkingInterface
import UIKit
import Shared
import ShowDetailsFeatureInterface
import ShowDetailsFeature

public class ShowDetailsDemoCoordinator: Coordinator {
  private let window: UIWindow
  private let tabBarController: UITabBarController
  private let apiDataTransferService: DataTransferService
  private let imagesBaseURL: String
  private var childCoordinators = [Coordinator]()

  // MARK: - Life Cycle
  public init(window: UIWindow,
              tabBarController: UITabBarController,
              apiDataTransferService: DataTransferService,
              imagesBaseURL: String) {
    self.window = window
    self.tabBarController = tabBarController
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
  }

  public func start() {
    showMainFeatures()
  }

  private func showMainFeatures() {
    // MARK: - TODO, build ViewController with a button and navigate then t the Coordinator.
    let detailsNavigation = UINavigationController(rootViewController: UIViewController())
    detailsNavigation.tabBarItem = UITabBarItem(title: "Custom Details", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    buildDetailsScene(in: detailsNavigation)

    tabBarController.setViewControllers([detailsNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildDetailsScene(in navigation: UINavigationController) {
    let dependencies = ShowDetailsFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                      imagesBaseURL: imagesBaseURL,
                                                                      showsPersistenceRepository: FakeShowsVisitedLocalRepository())
    let module = ShowDetailsFeature.Module(dependencies: dependencies)
    let coordinator = module.buildModuleCoordinator(in: navigation, delegate: self)
    coordinator.navigate(to: .showDetailsIsRequired(withId: 1416, closures: nil)) // Greys Anatomy
    childCoordinators.append(coordinator)
  }
}

extension ShowDetailsDemoCoordinator: TVShowDetailCoordinatorDelegate {
  public func tvShowDetailCoordinatorDidFinish() {
    print("call to tvShowDetailCoordinatorDidFinish")
  }
}

// MARK: - ShowsVisitedLocalRepository
final class FakeShowsVisitedLocalRepository: ShowsVisitedLocalRepository {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Just(()).setFailureType(to: CustomError.self).eraseToAnyPublisher()
  }

  public func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisited], CustomError> {
    return Just([]).setFailureType(to: CustomError.self).eraseToAnyPublisher()
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return Just(true).eraseToAnyPublisher()
  }
}
