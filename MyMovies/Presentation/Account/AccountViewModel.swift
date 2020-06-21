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
  
  private let fetchAccountDetails: FetchAccountDetailsUseCase
  
  private let behaviorSubjectViewState: BehaviorSubject<ViewState> = .init(value: .login)
  
  var steps = PublishRelay<Step>()
  
  var input: Input
  
  var output: Output
  
  private var signInViewModel: SignInViewModel
  
  private var profileViewMoel: ProfileViewModel
  
  private let disposeBag = DisposeBag()
  
  // TODO, delete this
  private var tempToken: String = ""
  
  // MARK: - Initializers
  
  init(requestToken: CreateTokenUseCase,
       createNewSession: CreateSessionUseCase,
       fetchAccountDetails: FetchAccountDetailsUseCase,
       signInViewModel: SignInViewModel, profileViewMoel: ProfileViewModel) {
    self.requestToken = requestToken
    self.createNewSession = createNewSession
    self.fetchAccountDetails = fetchAccountDetails
    self.signInViewModel = signInViewModel
    self.profileViewMoel = profileViewMoel
    
    input = Input()
    output = Output(viewState: behaviorSubjectViewState.asObservable())
  }
  
  fileprivate func requestCreateToken() {
    requestToken.execute()
      .subscribe(onNext: { [weak self] (url, token) in
        guard let strongSelf = self else { return }
        strongSelf.tempToken = token
        strongSelf.steps.accept( AccountStep.signInIsPicked(url: url, delegate: strongSelf) )
        }, onError: { error in
          //process error, viewState
          print("error to request token: \(error)")
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func createSession() {
    createNewSession.execute(requestToken: tempToken)
      .debug()
      .subscribe(onNext: { [weak self] result in
        print("Session Creada Ok: [\(result)]")
        self?.behaviorSubjectViewState.onNext(.profile)
        
        guard let session = result.sessionId else { return }
        self?.getDetails(session: session)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func getDetails(session: String) {
    fetchAccountDetails.execute(session: session)
      .subscribe(onNext: { [weak self] result in
        print("Details Okey: [\(result)]")
      })
      .disposed(by: disposeBag)
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
