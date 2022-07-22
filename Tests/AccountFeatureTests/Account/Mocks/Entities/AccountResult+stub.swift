//
//  AccountResult+stub.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
@testable import AccountFeature

extension Account {

  static func stub(
    accountId: Int = 1,
    userName: String = "userName",
    avatarURL: URL? = nil
  ) -> Self {
    Account(
      id: accountId,
      userName: userName,
      avatarURL: avatarURL
    )
  }
}
