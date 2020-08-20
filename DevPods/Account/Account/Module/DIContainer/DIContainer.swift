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
  
  private lazy var showListDependencies: TVShowsList.ModuleDependencies = {
    return TVShowsList.ModuleDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                          imagesBaseURL: dependencies.imagesBaseURL,
                                          showsPersistence: dependencies.showsPersistence)
  }()
  
  private var accountViewModel: AccountViewModel?
  
  // MARK: - Initializer
  
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
    
    // This init methods are Ok, because acountViewModel its a Long-Lived dependency
    
    func makeCreateSessionUseCase() -> CreateSessionUseCase {
      return DefaultCreateSessionUseCase(authRepository: authRepository,
                                         keyChainRepository: keychainRepository)
    }
    
    func makeFetchAccountDetailsUseCase() -> FetchAccountDetailsUseCase {
      return DefaultFetchAccountDetailsUseCase(accountRepository: accountRepository,
                                               keychainRepository: keychainRepository)
    }
    
    func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
      return DefaultFetchLoggedUser(keychainRepository: keychainRepository)
    }
    
    func makeDeleteLoguedUserUseCase() -> DeleteLoguedUserUseCase {
      return DefaultDeleteLoguedUserUseCase(keychainRepository: keychainRepository)
    }
    
    accountViewModel = AccountViewModel(createNewSession: makeCreateSessionUseCase(),
                                        fetchAccountDetails: makeFetchAccountDetailsUseCase(),
                                        fetchLoggedUser: makeFetchLoggedUserUseCase(),
                                        deleteLoguedUser: makeDeleteLoguedUserUseCase())
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
}

// MARK: - AccountCoordinatorDependencies

extension DIContainer: AccountCoordinatorDependencies {
  
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController {
    guard let accountViewModel = accountViewModel else { return UIViewController(nibName: nil, bundle: nil) }
    accountViewModel.coordinator = coordinator
    return AccountViewController.create(with: accountViewModel, viewControllersFactory: self)
  }
  
  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) -> UIViewController {
    let authViewModel = AuthPermissionViewModel(url: url)
    authViewModel.delegate = delegate
    return AuthPermissionViewController.create(with: authViewModel)
  }
  
  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinator {
    let module = TVShowsList.Module(dependencies: showListDependencies)
    let coordinator = module.buildModuleCoordinator(in: navigationController, delegate: delegate)
    return coordinator
  }
}

// MARK: - AccountViewControllerFactory

extension DIContainer: AccountViewControllerFactory {
  
  func makeSignInViewController() -> UIViewController {
    let signViewModel = SignInViewModel(createTokenUseCase: makeCreateTokenUseCase())
    signViewModel.delegate = accountViewModel
    return SignInViewController.create(with: signViewModel)
  }
  
  func makeProfileViewController(with account: AccountResult) -> UIViewController {
    let profileViewModel = ProfileViewModel(account: account)
    profileViewModel.delegate = accountViewModel
    return ProfileViewController.create(with: profileViewModel)
  }
}
