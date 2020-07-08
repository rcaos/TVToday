//
//  AppFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow
import Networking
import Persistence

class AppFlow: Flow {
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let appConfigurations: AppConfigurations
    let showsPersistence: ShowsVisitedLocalRepository
    let searchsPersistence: SearchLocalRepository
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    let controller = UIViewController()
    controller.view.backgroundColor = .white
    return rootWindow.rootViewController ?? controller
  }
  
  private let rootWindow: UIWindow
  
  // MARK: - Life Cycle
  
  public init(
    window: UIWindow, dependencies: Dependencies) {
    self.rootWindow = window
    self.dependencies = dependencies
  }
  
  func navigate(to step: Step) -> FlowContributors {
    
    switch step {
    case AppStep.applicationAuthorized :
      return nagivateToSignedFlow()
      
    default:
      return .none
    }
  }
  
  fileprivate func nagivateToSignedFlow() -> FlowContributors {
    let signedFlow = SignedFlow(dependencies:
      SignedFlow.Dependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        appConfigurations: dependencies.appConfigurations,
        showsPersistence: dependencies.showsPersistence,
        searchsPersistence: dependencies.searchsPersistence))
    Flows.whenReady(flow1: signedFlow) { root in
      DispatchQueue.main.async {
        self.rootWindow.rootViewController = root
        self.rootWindow.makeKeyAndVisible()
      }
    }
    
    return .one(
      flowContributor: .contribute(
        withNextPresentable: signedFlow, withNextStepper: OneStepper(withSingleStep: SignedStep.signedInit)))
  }
  
}

// MARK: - Steps

public enum AppStep: Step {
  
  case
  
  // First Launch
  applicationFirstLaunch,
  
  // Session token expire
  // applicationUnauthorized,
  
  // Default Launch
  applicationAuthorized,
  
  // Launch app from tapping Notification and is already LoggedIn
  applicationFromNotification
}
