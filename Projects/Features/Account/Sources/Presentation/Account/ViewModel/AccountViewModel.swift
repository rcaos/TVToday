//
//  AccountViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine
import NetworkingInterface
import RxSwift
import Shared

enum AccountViewState: Equatable {
  case login
  case profile(account: AccountResult)
}

protocol AccountViewModelProtocol: AuthPermissionViewModelDelegate {
  var viewState: Observable<AccountViewState> { get }
}

final class AccountViewModel: AccountViewModelProtocol {
  private let createNewSession: CreateSessionUseCase

  private let fetchLoggedUser: FetchLoggedUser

  private let fetchAccountDetails: FetchAccountDetailsUseCase

  private let deleteLoguedUser: DeleteLoguedUserUseCase

  private let viewStateSubject: BehaviorSubject<AccountViewState> = .init(value: .login)

  weak var coordinator: AccountCoordinatorProtocol?

  private let disposeBag = DisposeBag()
  private var cancelables = Set<AnyCancellable>()

  // MARK: - Public Api
  let viewState: Observable<AccountViewState>

  // MARK: - Initializers
  init(createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       fetchLoggedUser: FetchLoggedUser,
       deleteLoguedUser: DeleteLoguedUserUseCase) {
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoggedUser = fetchLoggedUser
    self.deleteLoguedUser = deleteLoguedUser

    viewState = viewStateSubject.asObservable()

    checkIsLogued()
  }

  fileprivate func checkIsLogued() {
    if fetchLoggedUser.execute() != nil {
      fetchUserDetails()
    } else {
      viewStateSubject.onNext(.login)
    }
  }

  private func fetchUserDetails() {
    fetchDetailsAccount()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure:
          self?.viewStateSubject.onNext(.login)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] accountDetails in
        self?.viewStateSubject.onNext(.profile(account: accountDetails))
      })
      .store(in: &cancelables)
  }

  private func createSession() {
    createNewSession.execute()
      .flatMap { [weak self] () -> AnyPublisher<AccountResult, DataTransferError> in
        guard let strongSelf = self else {
          return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
        }
        return strongSelf.fetchDetailsAccount()
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure:
          self?.viewStateSubject.onNext(.login)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] accountDetails in
        self?.viewStateSubject.onNext(.profile(account: accountDetails))
      })
      .store(in: &cancelables)
  }

  private func fetchDetailsAccount() -> AnyPublisher<AccountResult, DataTransferError> {
    return fetchAccountDetails.execute()
  }

  fileprivate func logoutUser() {
    deleteLoguedUser.execute()
    viewStateSubject.onNext(.login)
  }

  // MARK: - Navigation
  fileprivate func navigateTo(step: AccountStep) {
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
  func authPermissionViewModel(didSignedIn signedIn: Bool) {
    createSession()
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
