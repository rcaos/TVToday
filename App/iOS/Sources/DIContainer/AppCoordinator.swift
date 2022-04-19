//
//  AppCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

//import Foundation
//import UIKit
//import NetworkingInterface
//import Persistence
//import Shared
//
//public enum AppChildCoordinator {
//  case signed
//  // case signUp, login, onboarding, etc
//}
//
//class AppCoordinator: Coordinator {
//
//  private let window: UIWindow
//
//  private var childCoordinators = [AppChildCoordinator: Coordinator]()
//
//  private let appDIContainer: AppDIContainer
//
//  // MARK: - Initializer
//  public init(window: UIWindow, appDIContainer: AppDIContainer) {
//    self.window = window
//    self.appDIContainer = appDIContainer
//  }
//
//  func start() {
//    navigateToSignedFlow()
//  }
//
//  fileprivate func navigateToSignedFlow() {
//    let tabBar = UITabBarController()
//    let coordinator = SignedCoordinator(tabBarController: tabBar,
//                                        appDIContainer: appDIContainer)
//
//    self.window.rootViewController = tabBar
//    self.window.makeKeyAndVisible()
//
//    childCoordinators[.signed] = coordinator
//    coordinator.start()
//  }
//}
