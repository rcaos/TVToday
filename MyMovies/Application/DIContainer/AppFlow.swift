//
//  AppFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

class AppFlow: Flow {
  
  public var root: Presentable {
    let controller = UIViewController()
    controller.view.backgroundColor = .white
    return rootWindow.rootViewController ?? controller
  }
  
  private let rootWindow: UIWindow
  
  // Dependencies, use struct instead
  private let apiDataTransferService: DataTransferService
  private let imageTransferService: DataTransferService
  
  // MARK: - Life Cycle
  public init(
    window: UIWindow,
    apiDataTransferService: DataTransferService,
    imageTransferService: DataTransferService) {
    self.rootWindow = window
    self.apiDataTransferService = apiDataTransferService
    self.imageTransferService = imageTransferService
  }
  
  func navigate(to step: Step) -> FlowContributors {
    
    switch step {
    case AppStep.applicationAuthorized :
      return nagivateToSignedFlow()
      
      //case AppStep.applicationFirstLaunch
      // todo, splitVC
      
    default:
      return .none
    }
  }
  
  fileprivate func nagivateToSignedFlow() -> FlowContributors {
    let signedFlow = SignedFlow(apiDataTransferService: apiDataTransferService, imageTransferService: imageTransferService)
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
  
  /// First Launch
  applicationFirstLaunch,
  
  /// Session token expire
  // applicationUnauthorized,
  
  /// Default Launch
  applicationAuthorized,
  
  /// Launch app from tapping Notification and is already LoggedIn
  applicationFromNotification
}

