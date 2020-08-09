//
//  SignInViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift
@testable import AccountTV

final class SignInViewModelMock: SignInViewModelProtocol {
  
  func changeState(with state: SignInViewState) { }
  
  let tapButton = PublishSubject<Void>()
  
  let viewState: Observable<SignInViewState>
  
  weak var delegate: SignInViewModelDelegate?
  
  init(state: SignInViewState) {
    viewState = Observable.just(state)
  }
}
