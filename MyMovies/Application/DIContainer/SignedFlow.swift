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
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let appConfigurations: AppConfigurations
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UITabBarController = {
    let tabBarController = UITabBarController()
    return tabBarController
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
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
    let airingTodayFlow = AiringTodayFlow(dependencies:
      AiringTodayFlow.Dependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        appConfigurations: dependencies.appConfigurations) )
    
    let popularFlow = PopularFlow(dependencies:
      PopularFlow.Dependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        appConfigurations: dependencies.appConfigurations) )
    
    let searchFlow = SearchFlow(dependencies:
      SearchFlow.Dependencies(
        apiDataTransferService: dependencies.apiDataTransferService,
        appConfigurations: dependencies.appConfigurations) )
    
    Flows.whenReady(
      flow1: airingTodayFlow,
      flow2: popularFlow,
      flow3: searchFlow) { (airingTodayRoot: UINavigationController, popularRoot: UINavigationController, searchRoot: UINavigationController) in
      
      let airingTodayTabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "calendar"), tag: 0)
      airingTodayRoot.tabBarItem = airingTodayTabBarItem
      
      let popularTabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "popular"), tag: 1)
      popularRoot.tabBarItem = popularTabBarItem
      
      let searchTabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
      searchRoot.tabBarItem = searchTabBarItem
      
      self.rootViewController.setViewControllers([airingTodayRoot, popularRoot, searchRoot], animated: true)
    }
    
    return .multiple(flowContributors: [
      .contribute(withNextPresentable: airingTodayFlow, withNextStepper:
        OneStepper(withSingleStep: AiringTodayStep.todayFeatureInit)),
      .contribute(withNextPresentable: popularFlow, withNextStepper:
        OneStepper(withSingleStep: PopularStep.popularFeatureInit)),
      .contribute(withNextPresentable: searchFlow, withNextStepper:
        OneStepper(withSingleStep: SearchStep.searchFeatureInit))
    ])
    
  }
}

// MARK: - Steps

public enum SignedStep: Step {
  
  case
  
  signedInit
}
