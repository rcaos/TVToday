//
//  AccountFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow
import Networking
import Shared
import TVShowsList

public class AccountFlow: Flow {
  
  private let dependencies: AccountDependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // MARK: - Repositories
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var authRepository: AuthRepository = {
    return DefaultAuthRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var accountRepository: AccountRepository = {
    return DefaultAccountRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var keychainRepository: KeychainRepository = {
    return DefaultKeychainRepository()
  }()
  
  // MARK: - Dependencies
  
  private lazy var showListDependencies: ShowListDependencies = {
    return ShowListDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                imagesBaseURL: dependencies.imagesBaseURL,
                                showsPersistence: dependencies.showsPersistence)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: AccountDependencies) {
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
      
    case AccountStep.favoritesIsPicked:
      return navigateToFavorites()
      
    case AccountStep.watchListIsPicked:
      return navigateToWatchList()
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
                                            fetchLoggedUser: makeFetchLoggedUserUseCase(),
                                            deleteLoguedUser: makeDeleteLoguedUserUseCase(),
                                            signInViewModel: signViewModel,
                                            profileViewMoel: profileViewModel)
    signViewModel.delegate = accountViewModel
    profileViewModel.delegate = accountViewModel
    let accountViewController = AccountViewController.create(with: accountViewModel,
                                                             signInViewController: signInViewController,
                                                             profileViewController: profileViewController)
    
    rootViewController.pushViewController(accountViewController, animated: true)
    
    return .none
//    return .one(flowContributor: .contribute(
//      withNextPresentable: accountViewController, withNextStepper: accountViewModel))
  }
  
  fileprivate func navigateToAuthPermission(url: URL, delegate: AuthPermissionViewModelDelegate?) -> FlowContributors {
    let authViewModel = AuthPermissionViewModel(url: url)
    authViewModel.delegate = delegate
    let authViewController = AuthPermissionViewController.create(with: authViewModel)
    
    let navController = UINavigationController(rootViewController: authViewController)
    
    rootViewController.present(navController, animated: true)
    
    return .none
  }
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() -> FlowContributors {
    return .none
//    let listFlow = TVShowsListFlow(rootViewController: rootViewController,
//                                   dependencies: showListDependencies)
//
//    return .one(flowContributor: .contribute(
//      withNextPresentable: listFlow,
//      withNextStepper:
//      OneStepper(withSingleStep: TVShowListStep.favoriteList)))
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() -> FlowContributors {
    return .none
//    let listFlow = TVShowsListFlow(rootViewController: rootViewController,
//                                   dependencies: showListDependencies)
//    
//    return .one(flowContributor: .contribute(
//      withNextPresentable: listFlow, withNextStepper:
//      OneStepper(withSingleStep: TVShowListStep.watchList)))
  }
  
  // MARK: - Uses Cases
  
  private func makeCreateTokenUseCase() -> CreateTokenUseCase {
    return DefaultCreateTokenUseCase(authRepository: authRepository, keyChainRepository: keychainRepository)
  }
  
  private func makeCreateSessionUseCase() -> CreateSessionUseCase {
    return DefaultCreateSessionUseCase(authRepository: authRepository, keyChainRepository: keychainRepository)
  }
  
  private func makeFetchAccountDetailsUseCase() -> FetchAccountDetailsUseCase {
    return DefaultFetchAccountDetailsUseCase(accountRepository: accountRepository, keychainRepository: keychainRepository)
  }
  
  private func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
    return DefaultFetchLoggedUser(keychainRepository: keychainRepository)
  }
  
  private func makeDeleteLoguedUserUseCase() -> DeleteLoguedUserUseCase {
    return DefaultDeleteLoguedUserUseCase(keychainRepository: keychainRepository)
  }
}

// MARK: - Steps

public enum AccountStep: Step {
  
  case
  
  accountFeatureInit,
  
  signIsShow,
  
  profileIsShow,
  
  signInIsPicked(url: URL, delegate: AuthPermissionViewModelDelegate?),
  
  authorizationIsComplete,
  
  favoritesIsPicked,
  
  watchListIsPicked
}
