//
//  AccountResult+stub.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

@testable import AccountFeature

extension Account {

  static func stub(
    accountId: Int = 1,
    userName: String = "userName",
    avatarId: String? = nil
  ) -> Self {
    Account(
      id: accountId,
      userName: userName,
      avatar: Avatar(hashId: avatarId)
    )
  }
}
