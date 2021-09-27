//
//  SignInViewModelDelegateMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
@testable import Account

final class SignInViewModelDelegateMock: SignInViewModelDelegate {
  
  var url: URL?
  
  func signInViewModel(_ signInViewModel: SignInViewModel,
                       didTapSignInButton url: URL) {
    self.url = url
  }
}
