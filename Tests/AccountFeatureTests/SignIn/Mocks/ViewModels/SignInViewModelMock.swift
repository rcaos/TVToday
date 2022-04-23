//
//  SignInViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import AccountFeature

final class SignInViewModelMock: SignInViewModelProtocol {

  func signInDidTapped() { }
  func changeState(with state: SignInViewState) { }

  let viewState: CurrentValueSubject<SignInViewState, Never>
  weak var delegate: SignInViewModelDelegate?

  init(state: SignInViewState) {
    viewState = CurrentValueSubject(state)
  }
}
