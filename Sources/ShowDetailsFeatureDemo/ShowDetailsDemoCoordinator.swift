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
                                                                      showsPersistenceRepository: FakeShowsVisitedLocalRepository(),
                                                                      loggedUserRepository: FakeLoggedUserRepository())
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

// MARK: - LoggedUserRepositoryProtocol
final class FakeLoggedUserRepository: LoggedUserRepositoryProtocol {
  func saveUser(userId: Int, sessionId: String) { }

  func getUser() -> AccountDomain? {
    return nil
    // return AccountDomain(id: 1, sessionId: "mock")  // Must be a valid userId and sessionId
  }

  func deleteUser() { }
}

// MARK: - ShowsVisitedLocalRepository
final class FakeShowsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol {
  func saveShow(id: Int, pathImage: String) -> AnyPublisher<Void, ErrorEnvelope> {
    return Just(()).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
  }

  func fetchVisitedShows() -> AnyPublisher<[ShowVisited], ErrorEnvelope> {
    return Just([]).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return Just(true).eraseToAnyPublisher()
  }
}
