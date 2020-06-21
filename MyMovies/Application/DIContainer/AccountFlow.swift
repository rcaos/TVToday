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
  
  private lazy var authRepository: AuthRepository = {
    return DefaultAuthRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var accountRepository: AccountRepository = {
    return DefaultAccountRepository(dataTransferService: dependencies.apiDataTransferService)
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
      
    case AccountStep.signInIsPicked(let url, let delegate):
      return navigateToAuthPermission(url: url, delegate: delegate)
      
    case AccountStep.authorizationIsComplete:
      self.rootViewController.presentedViewController?.dismiss(animated: true)
      return .none
      
    default:
      return .none
    }
  }
  
  fileprivate func navigateToAccountFeature() -> FlowContributors {
    
    let signViewModel = SignInViewModel()
    let signInViewController = SignInViewController.create(with: signViewModel)
    
    let profileViewModel = ProfileViewModel()
    let profileViewController = ProfileViewController.create(with: profileViewModel)
    
    let accountViewModel = AccountViewModel(requestToken: makeCreateTokenUseCase(),
                                            createNewSession: makeCreateSessionUseCase(),
                                            fetchAccountDetails: makeFetchAccountDetailsUseCase(),
                                            signInViewModel: signViewModel,
                                            profileViewMoel: profileViewModel)
    signViewModel.delegate = accountViewModel
    let accountViewController = AccountViewController.create(with: accountViewModel,
                                                             signInViewController: signInViewController,
                                                             profileViewController: profileViewController)
    
    rootViewController.pushViewController(accountViewController, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: accountViewController, withNextStepper: accountViewModel))
  }
  
  fileprivate func navigateToAuthPermission(url: URL, delegate: AuthPermissionViewModelDelegate?) -> FlowContributors {
    let authViewModel = AuthPermissionViewModel(url: url)
    authViewModel.delegate = delegate
    let authViewController = AuthPermissionViewController.create(with: authViewModel)
    
    let navController = UINavigationController(rootViewController: authViewController)
    
    rootViewController.present(navController, animated: true)
    
    return .none
  }
  
  // MARK: - Uses Cases
  
  private func makeCreateTokenUseCase() -> CreateTokenUseCase {
    return DefaultCreateTokenUseCase(authRepository: authRepository)
  }
  
  private func makeCreateSessionUseCase() -> CreateSessionUseCase {
    return DefaultCreateSessionUseCase(authRepository: authRepository)
  }
  
  private func makeFetchAccountDetailsUseCase() -> FetchAccountDetailsUseCase {
    return DefaultFetchAccountDetailsUseCase(accountRepository: accountRepository)
  }
  
}

// MARK: - Steps

enum AccountStep: Step {
  
  case
  
  accountFeatureInit,
  
  signIsShow,
  
  profileIsShow,
  
  signInIsPicked(url: URL, delegate: AuthPermissionViewModelDelegate?),
  
  authorizationIsComplete
}
