//
//  AccountFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

public class AccountFlow: Flow {
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let appConfigurations: AppConfigurations
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // Repositories
  // TODO
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.appConfigurations.imagesBaseURL)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case AccountStep.accountFeatureInit:
      return navigateToAccountFeature()
      
//    case PopularStep.showIsPicked(let id) :
//      return navigateToShowDetailScreen(with: id)
      
    default:
      return .none
    }
  }
  
  fileprivate func navigateToAccountFeature() -> FlowContributors {
    
    let signViewModel = SignInViewModel()
    let signInViewController = SignInViewController.create(with: signViewModel)
    
    let profileViewModel = ProfileViewModel()
    let profileViewController = ProfileViewController.create(with: profileViewModel)
    
    let accountViewModel = AccountViewModel(signInViewModel: signViewModel, profileViewMoel: profileViewModel)
    let accountViewController = AccountViewController.create(with: accountViewModel,
                                                 signInViewController: signInViewController,
                                                 profileViewController: profileViewController)
    
    rootViewController.pushViewController(accountViewController, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: accountViewController, withNextStepper: accountViewModel))
  }
  
  // MARK: - Uses Cases
  
//  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
//    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
//  }
  
}

// MARK: - Steps

public enum AccountStep: Step {
  
  case
  
  accountFeatureInit,
  
  profile,
  
  signInIsPicked
    
  //showIsPicked(withId: Int)
}
