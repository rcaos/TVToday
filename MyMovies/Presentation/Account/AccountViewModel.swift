//
//  AccountViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift

final class AccountViewModel {
  
  private let requestToken: CreateTokenUseCase
  
  private let createNewSession: CreateSessionUseCase
  
  private let fetchLoggedUser: FetchLoggedUser
  
  private let fetchAccountDetails: FetchAccountDetailsUseCase
  
  private let deleteLoguedUser: DeleteLoguedUserUseCase
  
  private let viewStateSubject: BehaviorSubject<ViewState> = .init(value: .login)
  
  var steps = PublishRelay<Step>()
  
  var input: Input
  
  var output: Output
  
  private var signInViewModel: SignInViewModel
  
  private var profileViewModel: ProfileViewModel
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(requestToken: CreateTokenUseCase,
       createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       fetchLoggedUser: FetchLoggedUser,
       deleteLoguedUser: DeleteLoguedUserUseCase,
       signInViewModel: SignInViewModel,
       profileViewMoel: ProfileViewModel) {
    self.requestToken = requestToken
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoggedUser = fetchLoggedUser
    self.deleteLoguedUser = deleteLoguedUser
    self.signInViewModel = signInViewModel
    self.profileViewModel = profileViewMoel
    
    input = Input()
    output = Output(viewState: viewStateSubject.asObservable())
    
    checkIsLogued()
  }
  
  fileprivate func checkIsLogued() {
    if let loggedUser = fetchLoggedUser.execute() {
      print("loguedUser: [\(loggedUser)]")
      fetchUserDetails()
    } else {
      print("loguedUser: [not found]")
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
        strongSelf.steps.accept( AccountStep.signInIsPicked(url: url, delegate: strongSelf) )
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
      
      }, onError: { [weak self] error in
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
    steps.accept(AccountStep.authorizationIsComplete)
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
      steps.accept(AccountStep.favoritesIsPicked)
    case .watchList:
      steps.accept(AccountStep.watchListIsPicked)
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
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
}

extension AccountViewModel {
  
  enum ViewState {
    case login,
    
    profile
  }
}
