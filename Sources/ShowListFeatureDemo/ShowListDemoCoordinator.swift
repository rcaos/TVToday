//
//  File.swift
//  
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
    // MARK: - TODO, build ViewController with a button and navigate to Favorites and WhiteList
    let detailsNavigation = UINavigationController(rootViewController: UIViewController())
    detailsNavigation.tabBarItem = UITabBarItem(title: "Custom Details", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    buildListScene(in: detailsNavigation)

    tabBarController.setViewControllers([detailsNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildListScene(in navigation: UINavigationController) {
    let dependencies = ShowListFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                   imagesBaseURL: imagesBaseURL,
                                                                   showDetailsBuilder: self)
    let module = ShowListFeature.Module(dependencies: dependencies)
    let coordinator = module.buildModuleCoordinator(in: navigation, delegate: nil)
    coordinator.navigate(to: .favoriteList)
    // coordinator.navigate(to: .watchList)
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
