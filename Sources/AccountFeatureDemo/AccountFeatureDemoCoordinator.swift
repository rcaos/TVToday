//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 20/04/22.
//

import UIKit
import Shared
import NetworkingInterface
import AccountFeature
import ShowListFeatureInterface

public class AccountFeatureDemoCoordinator: Coordinator {
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
    let accountNavigation = UINavigationController()
    accountNavigation.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle.fill"), tag: 3)
    buildAccountCoordinator(in: accountNavigation)

    tabBarController.setViewControllers([accountNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildAccountCoordinator(in navigation: UINavigationController) {
    let dependencies = AccountFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                         imagesBaseURL: imagesBaseURL,
                                                         showListBuilder: self)
    let module = AccountFeature.Module(dependencies: dependencies)
    let coordinator = module.buildAccountCoordinator(in: navigation)
    coordinator.start()
    childCoordinators.append(coordinator)
  }
}

extension AccountFeatureDemoCoordinator: ModuleShowListDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    return EmptyDetailCoordinator(navigationController: navigationController)
  }
}

// MARK: - TVShowDetailCoordinatorProtocol
class EmptyDetailCoordinator: TVShowListCoordinatorProtocol {
  let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func navigate(to step: TVShowListStep) {
    print("EmptyDetailCoordinator navigate to \(step)")
  }
}
