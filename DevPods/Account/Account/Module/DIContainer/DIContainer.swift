//
//  DIContainer.swift
//  Account
//
//  Created by Jeans Ruiz on 7/20/20.
//

import TVShowsList
import Shared

final class DIContainer {
  
  private let dependencies: ModuleDependencies
  
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
  
  // MARK: - Initializer
  
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Build Module Coordinator
  
  func buildModuleCoordinator(navigationController: UINavigationController) -> Coordinator {
    return AccountCoordinator(navigationController: navigationController, dependencies: self)
  }
  
  // MARK: - Uses Cases
  
  fileprivate func makeCreateTokenUseCase() -> CreateTokenUseCase {
    return DefaultCreateTokenUseCase(authRepository: authRepository,
                                     keyChainRepository: keychainRepository)
  }
  
  fileprivate func makeCreateSessionUseCase() -> CreateSessionUseCase {
    return DefaultCreateSessionUseCase(authRepository: authRepository,
                                       keyChainRepository: keychainRepository)
  }
  
  fileprivate func makeFetchAccountDetailsUseCase() -> FetchAccountDetailsUseCase {
    return DefaultFetchAccountDetailsUseCase(accountRepository: accountRepository,
                                             keychainRepository: keychainRepository)
  }
  
  fileprivate func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
    return DefaultFetchLoggedUser(keychainRepository: keychainRepository)
  }
  
  fileprivate func makeDeleteLoguedUserUseCase() -> DeleteLoguedUserUseCase {
    return DefaultDeleteLoguedUserUseCase(keychainRepository: keychainRepository)
  }
}

// MARK: - AccountCoordinatorDependencies

extension DIContainer: AccountCoordinatorDependencies {
  
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController {
    let signViewModel = SignInViewModel(createTokenUseCase: makeCreateTokenUseCase())
    let signInViewController = SignInViewController.create(with: signViewModel)
    
    let profileViewModel = ProfileViewModel()
    let profileViewController = ProfileViewController.create(with: profileViewModel)
    
    let accountViewModel = AccountViewModel(createNewSession: makeCreateSessionUseCase(),
                                            fetchAccountDetails: makeFetchAccountDetailsUseCase(),
                                            fetchLoggedUser: makeFetchLoggedUserUseCase(),
                                            deleteLoguedUser: makeDeleteLoguedUserUseCase(),
                                            signInViewModel: signViewModel,
                                            profileViewMoel: profileViewModel,
                                            coordinator: coordinator)
    signViewModel.delegate = accountViewModel
    profileViewModel.delegate = accountViewModel
    return AccountViewController.create(with: accountViewModel,
                                                             signInViewController: signInViewController,
                                                             profileViewController: profileViewController)
  }
  
  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) -> UIViewController {
    let authViewModel = AuthPermissionViewModel(url: url)
    authViewModel.delegate = delegate
    return AuthPermissionViewController.create(with: authViewModel)
  }
  
  func buildTVShowListCoordinator(navigationController: UINavigationController) -> TVShowListCoordinator {
    return TVShowListCoordinator(navigationController: navigationController,
                                 dependencies: showListDependencies)
  }
}
