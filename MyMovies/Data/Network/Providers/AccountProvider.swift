//
//  AccountProvider.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

enum AccountProvider {
  case accountDetails(sessionId: String)
}

extension AccountProvider: EndPoint {
  
  var path: String {
    switch self {
    case .accountDetails:
      return "/3/account"
    }
  }
  
  var queryParameters: [String: Any]? {
    switch self {
    case .accountDetails(let sessionId):
      return ["session_id": "\(sessionId)"]
    }
  }
  
  var method: ServiceMethod {
    switch self {
    case .accountDetails:
      return .get
    }
  }
}
