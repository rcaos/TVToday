//
//  AccountViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import Account

final class AccountViewModelMock: AccountViewModelProtocol {

  let viewState: CurrentValueSubject<AccountViewState, Never>

  init(state: AccountViewState) {
    viewState = CurrentValueSubject(state)
  }

  func authPermissionViewModel(didSignedIn signedIn: Bool) { }
}
