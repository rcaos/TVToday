//
//  DIContainer.swift
//  Account
//
//  Created by Jeans Ruiz on 7/20/20.
//

import UIKit
import Shared
import ShowListFeatureInterface

final class DIContainer {

  private let dependencies: ModuleDependencies

  private lazy var authRepository: AuthRepository = {
    return DefaultAuthRepository(
      remoteDataSource: DefaultAuthRemoteDataSource(dataTransferService: dependencies.apiDataTransferService),
      requestTokenRepository: keychainRepository,
      accessTokenRepository: keychainRepository
    )
  }()

  private lazy var accountRepository: AccountRepository = {
    return DefaultAccountRepository(
      remoteDataSource: DefaultAccountRemoteDataSource(dataTransferService: dependencies.apiDataTransferService),
      tokenRepository: keychainRepository,
      userLoggedRepository: keychainRepository
    )
  }()

  private lazy var keychainRepository = DefaultKeychainRepository() // KeychainRepository

  private var accountViewModel: AccountViewModel?

  // MARK: - Initializer
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies

    // This init methods are Ok, because acountViewModel its a Long-Lived dependency
    func makeCreateSessionUseCase() -> CreateSessionUseCase {
      return DefaultCreateSessionUseCase(authRepository: authRepository)
    }

    func makeFetchAccountDetailsUseCase() -> FetchAccountDetailsUseCase {
      return DefaultFetchAccountDetailsUseCase(accountRepository: accountRepository)
    }

    func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
      return DefaultFetchLoggedUser(loggedRepository: keychainRepository)
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
  private func makeCreateTokenUseCase() -> CreateTokenUseCase {
    return DefaultCreateTokenUseCase(authRepository: authRepository)
  }
}

// MARK: - AccountCoordinatorDependencies
extension DIContainer: AccountCoordinatorDependencies {
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController {
    guard let accountViewModel = accountViewModel else { return UIViewController(nibName: nil, bundle: nil) }
    accountViewModel.coordinator = coordinator
    return AccountViewController(viewModel: accountViewModel, viewControllersFactory: self)
  }

  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) -> AuthPermissionViewController {
    let authViewModel = AuthPermissionViewModel(url: url)
    authViewModel.delegate = delegate
    return AuthPermissionViewController(viewModel: authViewModel)
  }

  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    return dependencies.showListBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}

// MARK: - AccountViewControllerFactory
extension DIContainer: AccountViewControllerFactory {
  func makeSignInViewController() -> UIViewController {
    let signViewModel = SignInViewModel(createTokenUseCase: makeCreateTokenUseCase())
    signViewModel.delegate = accountViewModel
    return SignInViewController(viewModel: signViewModel)
  }

  func makeProfileViewController(with account: Account) -> UIViewController {
    let profileViewModel = ProfileViewModel(account: account)
    profileViewModel.delegate = accountViewModel
    return ProfileViewController(viewModel: profileViewModel)
  }
}
