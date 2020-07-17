//
//  SignedFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

import Networking
import AiringToday
import PopularShows
import SearchShows
import Account
import Shared
import Persistence

// MARK: - TODO:

public struct SignedDependencies {
  let apiDataTransferService: DataTransferService
  let appConfigurations: AppConfigurations
  let showsPersistence: ShowsVisitedLocalRepository
  let searchsPersistence: SearchLocalRepository
}

public class SignedCoordinator: FCoordinator {
  
  public var root: FPresentable {
    return self.rootViewController
  }
  
  public var childCoordinators: [FCoordinator] = []
  
  public var parentCoordinator: FCoordinator?
  
  public lazy var rootViewController: UITabBarController = {
    let tabBarController = UITabBarController()
    return tabBarController
  }()
  
  private let dependencies: SignedDependencies
  
  // MARK: - Life Cycle
  
  public init(dependencies: SignedDependencies) {
    self.dependencies = dependencies
  }
  
  public func start() {
    showMainFeatures()
  }
  
  fileprivate func showMainFeatures() {
    
    let airingTodayDependencies =
    AiringTodayDependencies(
      apiDataTransferService: dependencies.apiDataTransferService,
      imagesBaseURL: dependencies.appConfigurations.imagesBaseURL,
      showsPersistence: dependencies.showsPersistence)
    
    let airingTodayCoordinator = AiringTodayCoordinator(dependencies: airingTodayDependencies)
    
    let airingTodayTabBarItem = UITabBarItem(title: "Today",
                                             image: UIImage(name: "calendar"), tag: 0)
    
    if let root = airingTodayCoordinator.root as? UIViewController {
      root.tabBarItem = airingTodayTabBarItem
      
      rootViewController.setViewControllers([root], animated: true)
      airingTodayCoordinator.start()
    }
  }
}
