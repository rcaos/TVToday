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

final class AccountViewModel {
  
  private let requestToken: CreateTokenUseCase
  
  private let createNewSession: CreateSessionUseCase
  
  private let fetchLoggedUser: FetchLoggedUser
  
  private let fetchAccountDetails: FetchAccountDetailsUseCase
  
  private let deleteLoguedUser: DeleteLoguedUserUseCase
  
  private let viewStateSubject: BehaviorSubject<ViewState> = .init(value: .login)
  
  var input: Input
  
  var output: Output
  
  private var signInViewModel: SignInViewModel
  
  private var profileViewModel: ProfileViewModel
  
  private weak var coordinator: AccountCoordinatorProtocol?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(requestToken: CreateTokenUseCase,
       createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       fetchLoggedUser: FetchLoggedUser,
       deleteLoguedUser: DeleteLoguedUserUseCase,
       signInViewModel: SignInViewModel,
       profileViewMoel: ProfileViewModel,
       coordinator: AccountCoordinatorProtocol?) {
    self.requestToken = requestToken
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoggedUser = fetchLoggedUser
    self.deleteLoguedUser = deleteLoguedUser
    self.signInViewModel = signInViewModel
    self.profileViewModel = profileViewMoel
    self.coordinator = coordinator
    
    input = Input()
    output = Output(viewState: viewStateSubject.asObservable())
    
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
  
  fileprivate func requestCreateToken() {
    // TODO, test Error from Network
    
    requestToken.execute()
      .subscribe(onNext: { [weak self] url in
        guard let strongSelf = self else { return }
        strongSelf.coordinator?.navigate(to: .signInIsPicked(url: url, delegate: strongSelf))
        
        }, onError: { [weak self] error in
          print("error to request token: \(error)")
          self?.viewStateSubject.onNext(.login)
          self?.signInViewModel.changeState(with: .initial)
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
  func signInViewModel(_ signInViewModel: SignInViewModel, didTapSignInButton tapped: Bool) {
    requestCreateToken()
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

extension AccountViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<ViewState>
  }
}

extension AccountViewModel {
  
  enum ViewState {
    case login,
    
    profile
  }
}
