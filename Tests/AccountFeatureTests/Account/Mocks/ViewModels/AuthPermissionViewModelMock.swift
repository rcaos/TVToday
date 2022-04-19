//
//  AuthPermissionViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
import Combine
@testable import Account

class AuthPermissionViewModelMock: AuthPermissionViewModelProtocol {
  func signIn() {
    delegate?.authPermissionViewModel(didSignedIn: true)
  }

  var authPermissionURL = URL(string: "http://www.123.com")!

  weak var delegate: AuthPermissionViewModelDelegate?
}
