//
//  FetchLoggedUserMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

@testable import Shared

class FetchLoggedUserMock: FetchLoggedUser {
  
  var account: Account?
  
  func execute() -> Account? {
    return account
  }
}
