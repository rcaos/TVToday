//
//  AccountViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift
@testable import AccountTV

final class AccountViewModelMock: AccountViewModelProtocol {
  
  let viewState: Observable<AccountViewState>
  
  init(state: AccountViewState) {
    viewState = Observable.just(state)
  }
  
  func authPermissionViewModel(didSignedIn signedIn: Bool) { }
}
