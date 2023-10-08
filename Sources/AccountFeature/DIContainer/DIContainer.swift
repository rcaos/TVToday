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
      remoteDataSource: DefaultAuthRemoteDataSource(apiClient: dependencies.apiClient),
      requestTokenRepository: dependencies.requestTokenRepository,
      accessTokenRepository: dependencies.accessTokenRepository,
      tokenMapper: RequestTokenMapper(authenticateBaseURL: dependencies.authenticateBaseURL)
    )
  }()

  private lazy var accountRepository: AccountRepository = {
    return DefaultAccountRepository(
      remoteDataSource: DefaultAccountRemoteDataSource(apiClient: dependencies.apiClient),
      accessTokenRepository: dependencies.accessTokenRepository,
      userLoggedRepository: dependencies.userLoggedRepository,
      gravatarBaseURL: dependencies.gravatarBaseURL
    )
  }()

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
      return DefaultFetchLoggedUser(loggedRepository: dependencies.userLoggedRepository)
    }

    func makeDeleteLoggedUserUseCase() -> DeleteLoggedUserUseCase {
      return DefaultDeleteLoggedUserUseCase(loggedRepository: dependencies.userLoggedRepository)
    }

    accountViewModel = AccountViewModel(
      createNewSession: { makeCreateSessionUseCase() },
      fetchAccountDetails: { makeFetchAccountDetailsUseCase() },
      fetchLoggedUser: { makeFetchLoggedUserUseCase() },
      deleteLoggedUser: { makeDeleteLoggedUserUseCase() }
    )
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

  @MainActor
  func buildAccountViewController(coordinator: AccountCoordinatorProtocol?) -> UIViewController {
    guard let accountViewModel = accountViewModel else { return UIViewController(nibName: nil, bundle: nil) }
    accountViewModel.coordinator = coordinator
    return AccountViewController(viewModel: accountViewModel, viewControllersFactory: self)
  }

  @MainActor
  func buildAuthPermissionViewController(url: URL, delegate: AuthPermissionViewModelDelegate?) async -> AuthPermissionViewController {
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

  @MainActor
  func makeSignInViewController() async -> UIViewController {
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
