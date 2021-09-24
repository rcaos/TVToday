//
//  AccountResult+stub.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

@testable import AccountTV

extension AccountResult {
  
  static func stub(hash: String? = nil,
                   id: Int = 1,
                   userName: String = "userName") -> Self {
    AccountResult(avatar: Avatar(gravatar: Gravatar(hash: hash)),
                  id: id,
                  userName: userName)
  }
}
