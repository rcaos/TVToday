//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 20/04/22.
//

import UIKit
import AiringTodayFeature
import Shared
import NetworkingInterface
import ShowDetailsFeatureInterface

public class TodayDemoCoordinator: Coordinator {
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
    let todayNavigation = UINavigationController()
    todayNavigation.tabBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "calendar.badge.clock"), tag: 0)
    buildTodayScene(in: todayNavigation)

    tabBarController.setViewControllers([todayNavigation], animated: true)

    self.window.rootViewController = tabBarController
    self.window.makeKeyAndVisible()
  }

  private func buildTodayScene(in navigation: UINavigationController) {
    let dependencies = AiringTodayFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                             imagesBaseURL: imagesBaseURL,
                                                             showDetailsBuilder: self)
    let module = AiringTodayFeature.Module(dependencies: dependencies)
    let coordinator = module.buildAiringTodayCoordinator(in: navigation)
    coordinator.start()
    childCoordinators.append(coordinator)
  }
}

extension TodayDemoCoordinator: ModuleShowDetailsBuilder {
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
