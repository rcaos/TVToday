//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 20/04/22.
//

import UIKit
import PopularsFeature
import Shared
import NetworkingInterface
import ShowDetailsFeatureInterface

public class PopularDemoCoordinator: Coordinator {
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
    let popularNavigation = UINavigationController()
    popularNavigation.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "star.fill"), tag: 0)
    buildPopularScene(in: popularNavigation)

    tabBarController.setViewControllers([popularNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildPopularScene(in navigation: UINavigationController) {
    let dependencies = PopularsFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                             imagesBaseURL: imagesBaseURL,
                                                             showDetailsBuilder: self)
    let module = PopularsFeature.Module(dependencies: dependencies)
    let coordinator = module.buildPopularCoordinator(in: navigation)
    coordinator.start()
    childCoordinators.append(coordinator)
  }
}

extension PopularDemoCoordinator: ModuleShowDetailsBuilder {
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

