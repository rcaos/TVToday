//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation
import NetworkingInterface
import Shared

enum AccountViewState: Equatable {
  case login
  case profile(account: Account)
}

protocol AccountViewModelProtocol: AuthPermissionViewModelDelegate {
  func viewDidLoad() async
  var viewState: Published<AccountViewState>.Publisher { get }
}

final class AccountViewModel: AccountViewModelProtocol {
  private let createNewSession: () -> CreateSessionUseCase
  private let fetchLoggedUser: () -> FetchLoggedUser
  private let fetchAccountDetails: () -> FetchAccountDetailsUseCase
  private let deleteLoggedUser: () -> DeleteLoggedUserUseCase

  weak var coordinator: AccountCoordinatorProtocol?

  // MARK: - Public Api
  @Published private var viewStateInternal = AccountViewState.login
  var viewState: Published<AccountViewState>.Publisher { $viewStateInternal }

  // MARK: - Initializers
  init(
    createNewSession: @escaping () -> CreateSessionUseCase,
    fetchAccountDetails: @escaping () -> FetchAccountDetailsUseCase,
    fetchLoggedUser: @escaping () -> FetchLoggedUser,
    deleteLoggedUser: @escaping () -> DeleteLoggedUserUseCase
  ) {
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoggedUser = fetchLoggedUser
    self.deleteLoggedUser = deleteLoggedUser
  }

  func viewDidLoad() async {
    await checkIsLogged()
  }

  private func checkIsLogged() async {
    if fetchLoggedUser().execute() != nil {
      await fetchUserDetails()
    } else {
      viewStateInternal = .login
    }
  }

  private func fetchUserDetails() async {
    if let accountDetails = await fetchAccountDetails().execute() {
      viewStateInternal = .profile(account: accountDetails)
    } else {
      viewStateInternal = .login
    }
  }

  private func createSession() async {
    if await createNewSession().execute() {
      await fetchUserDetails()
    } else {
      viewStateInternal = .login
    }
  }

  private func logoutUser() {
    deleteLoggedUser().execute()
    viewStateInternal = .login
  }

  // MARK: - Navigation
  private func navigateTo(step: AccountStep) {
    coordinator?.navigate(to: step)
  }
}

// MARK: - SignInViewModelDelegate
extension AccountViewModel: SignInViewModelDelegate {
  func signInViewModel(_ signInViewModel: SignInViewModel, didTapSignInButton url: URL) {
    navigateTo(step: .signInIsPicked(url: url, delegate: self))
  }
}

// MARK: - AuthPermissionViewModelDelegate
extension AccountViewModel: AuthPermissionViewModelDelegate {

  @MainActor
  func authPermissionViewModel(didSignedIn signedIn: Bool) async {
    await createSession()
    navigateTo(step: .authorizationIsComplete)
  }
}

// MARK: - ProfileViewModelDelegate
extension AccountViewModel: ProfileViewModelDelegate {
  func profileViewModel(didTapLogoutButton tapped: Bool) {
    logoutUser()
  }

  func profileViewModel(didUserList tapped: UserListType) {
    switch tapped {
    case .favorites:
      navigateTo(step: .favoritesIsPicked)
    case .watchList:
      navigateTo(step: .watchListIsPicked)
    }
  }
}
