//
//  AccountViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import Shared

enum AccountViewState: Equatable {
   case login,
   
   profile
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
  
  private var signInViewModel: SignInViewModelProtocol
  
  private var profileViewModel: ProfileViewModelProtocol
  
  private weak var coordinator: AccountCoordinatorProtocol?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Public Api
  
  let viewState: Observable<AccountViewState>
  
  // MARK: - Initializers
  
  init(createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       fetchLoggedUser: FetchLoggedUser,
       deleteLoguedUser: DeleteLoguedUserUseCase,
       signInViewModel: SignInViewModelProtocol,
       profileViewMoel: ProfileViewModelProtocol,
       coordinator: AccountCoordinatorProtocol?) {
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoggedUser = fetchLoggedUser
    self.deleteLoguedUser = deleteLoguedUser
    self.signInViewModel = signInViewModel
    self.profileViewModel = profileViewMoel
    self.coordinator = coordinator
    
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
  
  fileprivate func fetchUserDetails() {
    fetchDetailsAccount()
      .subscribe(onNext: { [weak self] accountDetails in
        self?.viewStateSubject.onNext(.profile)
        self?.profileViewModel.createSectionModel(account: accountDetails)
        }, onError: { [weak self] _ in
          self?.viewStateSubject.onNext(.login)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func createSession() {
    createNewSession.execute()
      .flatMap { [weak self] () -> Observable<AccountResult> in
        guard let strongSelf = self else { return Observable.error(CustomError.genericError) }
        return strongSelf.fetchDetailsAccount()
    }
    .subscribe(onNext: { [weak self] accountDetails in
      self?.viewStateSubject.onNext(.profile)
      self?.signInViewModel.changeState(with: .initial)
      self?.profileViewModel.createSectionModel(account: accountDetails)
      
      }, onError: { [weak self] _ in
        self?.viewStateSubject.onNext(.login)
        self?.signInViewModel.changeState(with: .initial)
    })
      .disposed(by: disposeBag)
  }
  
  fileprivate func fetchDetailsAccount() -> Observable<AccountResult> {
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
