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
  
  private let fetchLoguedUser: FetchLoguedUser
  
  private let fetchAccountDetails: FetchAccountDetailsUseCase
  
  private let deleteLoguedUser: DeleteLoguedUserUseCase
  
  private let viewStateSubject: BehaviorSubject<ViewState> = .init(value: .login)
  
  var steps = PublishRelay<Step>()
  
  var input: Input
  
  var output: Output
  
  private var signInViewModel: SignInViewModel
  
  private var profileViewMoel: ProfileViewModel
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(requestToken: CreateTokenUseCase,
       createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       fetchLoguedUser: FetchLoguedUser,
       deleteLoguedUser: DeleteLoguedUserUseCase,
       signInViewModel: SignInViewModel,
       profileViewMoel: ProfileViewModel) {
    self.requestToken = requestToken
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.fetchLoguedUser = fetchLoguedUser
    self.deleteLoguedUser = deleteLoguedUser
    self.signInViewModel = signInViewModel
    self.profileViewMoel = profileViewMoel
    
    input = Input()
    output = Output(viewState: viewStateSubject.asObservable())
    
    checkIsLogued()
  }
  
  fileprivate func checkIsLogued() {
    if let loguedUser = fetchLoguedUser.execute() {
      print("loguedUser: [\(loguedUser)]")
      viewStateSubject.onNext(.profile)
    } else {
      print("loguedUser: [not found]")
      viewStateSubject.onNext(.login)
    }
  }
  
  fileprivate func requestCreateToken() {
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
    .subscribe(onNext: { [weak self] result in
      print("Details Okey: [\(result)]")
      self?.viewStateSubject.onNext(.profile)
      self?.signInViewModel.changeState(with: .initial)
      
      }, onError: { [weak self] error in
        print("Error to Create Session or Fetch Details: \(error)")
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
  func profileViewModel(_ profileViewModel: ProfileViewModel, didTapLogoutButton tapped: Bool) {
    logoutUser()
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
