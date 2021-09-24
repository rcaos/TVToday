//
//  Account+Stub.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

@testable import Shared

extension Account {
  
  static func stub(id: Int = 1,
                   sessionId: String = "session") -> Self {
    return Account(id: id, sessionId: sessionId)
  }
}
