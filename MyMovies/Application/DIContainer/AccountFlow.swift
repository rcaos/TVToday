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
  
  // MARK: - Repositories
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.appConfigurations.imagesBaseURL)
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
      
    case AccountStep.favoritesIsPicked:
      return navigateToFavorites()
      
    case AccountStep.watchListIsPicked:
      return navigateToWatchList()
      
    case SearchStep.showIsPicked(let id):
    return navigateToShowDetailScreen(with: id)
      
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
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() -> FlowContributors {
    let viewModel = TVShowListViewModel(filter: .favorites(userId: 0, sessionId: ""),
                                        fetchTVShowsUseCase: makeShowListUseCase())
    let showList = TVShowListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(showList, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: showList, withNextStepper: viewModel))
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() -> FlowContributors {
    let viewModel = TVShowListViewModel(filter: .watchList(userId: 0, sessionId: ""),
                                        fetchTVShowsUseCase: makeShowListUseCase())
    let showList = TVShowListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(showList, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: showList, withNextStepper: viewModel))
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
                                          dependencies: TVShowDetailFlow.Dependencies(
                                            apiDataTransferService: dependencies.apiDataTransferService,
                                            appConfigurations: dependencies.appConfigurations))
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailShowFlow,
      withNextStepper:
      OneStepper(withSingleStep:
        ShowDetailsStep.showDetailsIsRequired(withId: id))))
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
  
  fileprivate func makeShowListUseCase() -> FetchTVShowsUseCase {
    return DefaultUserFetchShowsUserUseCase(tvShowsRepository: showsRepository,
                                            keychainRepository: keychainRepository)
  }
  
}

// MARK: - Steps

enum AccountStep: Step {
  
  case
  
  accountFeatureInit,
  
  signIsShow,
  
  profileIsShow,
  
  signInIsPicked(url: URL, delegate: AuthPermissionViewModelDelegate?),
  
  authorizationIsComplete,
  
  favoritesIsPicked,
    
  watchListIsPicked
}
