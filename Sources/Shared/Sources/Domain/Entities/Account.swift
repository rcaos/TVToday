//
//  Account.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct AccountDomain {
  public let id: Int
  public let sessionId: String

  public init(id: Int, sessionId: String) {
    self.id = id
    self.sessionId = sessionId
  }
}
