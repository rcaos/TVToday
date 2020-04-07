//
//  SignedFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxFlow

public class SignedFlow: Flow {
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UITabBarController = {
    let tabBarController = UITabBarController()
    return tabBarController
  }()
  
  // Dependencies, use struct instead ?
  private let apiDataTransferService: DataTransferService
  private let imageTransferService: DataTransferService
  
  // MARK: - Life Cycle
  
  public init(
    apiDataTransferService: DataTransferService,
    imageTransferService: DataTransferService) {
    self.apiDataTransferService = apiDataTransferService
    self.imageTransferService = imageTransferService
  }
  
  public func navigate(to step: Step) -> FlowContributors {
    
    switch step {
    case SignedStep.signedInit :
      return showMainFeatures()
      
    default:
      return .none
    }
  }
  
  fileprivate func showMainFeatures() -> FlowContributors {
    let airingTodayFlow = AiringTodayFlow(
      apiDataTransferService: apiDataTransferService,
      imageTransferService: imageTransferService)
    
    Flows.whenReady(flow1: airingTodayFlow) {
      (airingTodayRoot: UINavigationController) in
      let airingTodayTabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "calendar"), tag: 0)
      airingTodayRoot.tabBarItem = airingTodayTabBarItem
      
      self.rootViewController.setViewControllers([airingTodayRoot], animated: true)
    }
    
    return .multiple(flowContributors: [
      .contribute(withNextPresentable: airingTodayFlow, withNextStepper: OneStepper(withSingleStep: AiringTodayStep.todayFeatureInit))
    ])
    
  }
}

// MARK: - Steps

public enum SignedStep: Step {
  
  case
  
  signedInit
}
