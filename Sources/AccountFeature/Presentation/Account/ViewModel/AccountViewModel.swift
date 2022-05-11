//
//  AccountViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine
import CombineSchedulers
import NetworkingInterface
import Shared

enum AccountViewState: Equatable {
  case login
  case profile(account: Account)
}

protocol AccountViewModelProtocol: AuthPermissionViewModelDelegate {
  func viewDidLoad()
  var viewState: CurrentValueSubject<AccountViewState, Never> { get }
}

final class AccountViewModel: AccountViewModelProtocol {
  private let createNewSession: CreateSessionUseCase
  private let fetchLoggedUser: FetchLoggedUser
  private let fetchAccountDetails: FetchAccountDetailsUseCase
  private let deleteLoggedUser: DeleteLoggedUserUseCase

  weak var coordinator: AccountCoordinatorProtocol?
  private var disposeBag = Set<AnyCancellable>()
  private let scheduler: AnySchedulerOf<DispatchQueue>

  // MARK: - Public Api
  let viewState: CurrentValueSubject<AccountViewState, Never> = .init(.login)

  // MARK: - Initializers
  init(createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       fetchLoggedUser: FetchLoggedUser,
       deleteLoggedUser: DeleteLoggedUserUseCase,
       scheduler: AnySchedulerOf<DispatchQueue> = .main
  ) {
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoggedUser = fetchLoggedUser
    self.deleteLoggedUser = deleteLoggedUser
    self.scheduler = scheduler
  }

  func viewDidLoad() {
    checkIsLogued()
  }

  private func checkIsLogued() {
    if fetchLoggedUser.execute() != nil {
      fetchUserDetails()
    } else {
      viewState.send(.login)
    }
  }

  private func fetchUserDetails() {
    fetchDetailsAccount()
      .receive(on: scheduler)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure:
          self?.viewState.send(.login)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] accountDetails in
        self?.viewState.send(.profile(account: accountDetails))
      })
      .store(in: &disposeBag)
  }

  private func createSession() {
    createNewSession.execute()
      .flatMap { [weak self] () -> AnyPublisher<Account, DataTransferError> in
        guard let strongSelf = self else {
          return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
        }
        return strongSelf.fetchDetailsAccount()
      }
      .receive(on: scheduler)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure:
          self?.viewState.send(.login)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] accountDetails in
        self?.viewState.send(.profile(account: accountDetails))
      })
      .store(in: &disposeBag)
  }

  private func fetchDetailsAccount() -> AnyPublisher<Account, DataTransferError> {
    return fetchAccountDetails.execute()
  }

  private func logoutUser() {
    deleteLoggedUser.execute()
    viewState.send(.login)
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
