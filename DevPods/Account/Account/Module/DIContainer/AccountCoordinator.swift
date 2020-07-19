//
//  AccountFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking
import Shared
import TVShowsList

public protocol AccountCoordinatorProtocol: class {
  
  func navigate(to step: AccountStep)
}

public enum AccountChildCoordinator {
  case
  
  tvShowList
}

public class AccountCoordinator: NavigationCoordinator, AccountCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  private var childCoordinators = [AccountChildCoordinator: NCoordinator]()
  
  private let dependencies: AccountDependencies
  
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
  
  public init(navigationController: UINavigationController, dependencies: AccountDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start() {
    navigate(to: .accountFeatureInit)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: AccountStep) {
    switch step {
    case .accountFeatureInit:
      navigateToAccountFeature()
      
    case .signInIsPicked(let url, let delegate):
      navigateToAuthPermission(url: url, delegate: delegate)
      
    case .authorizationIsComplete:
      navigationController.presentedViewController?.dismiss(animated: true)
      
    case .favoritesIsPicked:
      navigateToFavorites()
      
    case .watchListIsPicked:
      navigateToWatchList()
      
    }
  }
  
  fileprivate func navigateToAccountFeature() {
    
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
                                            profileViewMoel: profileViewModel,
                                            coordinator: self)
    signViewModel.delegate = accountViewModel
    profileViewModel.delegate = accountViewModel
    let accountViewController = AccountViewController.create(with: accountViewModel,
                                                             signInViewController: signInViewController,
                                                             profileViewController: profileViewController)
    
    navigationController.pushViewController(accountViewController, animated: true)
  }
  
  fileprivate func navigateToAuthPermission(url: URL, delegate: AuthPermissionViewModelDelegate?) {
    let authViewModel = AuthPermissionViewModel(url: url)
    authViewModel.delegate = delegate
    let authViewController = AuthPermissionViewController.create(with: authViewModel)
    
    let navController = UINavigationController(rootViewController: authViewController)
    
    navigationController.present(navController, animated: true)
  }
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() {
    let coordinator = TVShowListCoordinator(navigationController: navigationController, dependencies: showListDependencies)
    coordinator.delegate = self
    childCoordinators[.tvShowList] = coordinator
    coordinator.start(with: .favoriteList)
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() {
    let coordinator = TVShowListCoordinator(navigationController: navigationController, dependencies: showListDependencies)
    coordinator.delegate = self
    childCoordinators[.tvShowList] = coordinator
    coordinator.start(with: .watchList)
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

// MARK: - TVShowListCoordinatorDelegate

extension AccountCoordinator: TVShowListCoordinatorDelegate {
  
  public func tvShowListCoordinatorDidFinish() {
    childCoordinators[.tvShowList] = nil
  }
}

// MARK: - Steps

public enum AccountStep: MyStep {
  
  case
  
  accountFeatureInit,
  
  signInIsPicked(url: URL, delegate: AuthPermissionViewModelDelegate?),
  
  authorizationIsComplete,
  
  favoritesIsPicked,
  
  watchListIsPicked
}
