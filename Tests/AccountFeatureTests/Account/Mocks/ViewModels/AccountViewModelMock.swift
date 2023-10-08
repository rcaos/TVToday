//
//  AccountViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import AccountFeature

final class AccountViewModelMock: AccountViewModelProtocol {

  func viewDidLoad() async { }

  let viewState: CurrentValueSubject<AccountViewState, Never>

  init(state: AccountViewState) {
    viewState = CurrentValueSubject(state)
  }

  func authPermissionViewModel(didSignedIn signedIn: Bool) { }
}
