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
  case favorites(page: Int, userId: String, sessionId: String)
  case watchList(page: Int, userId: String, sessionId: String)
}

extension AccountProvider: EndPoint {
  
  var path: String {
    switch self {
    case .accountDetails:
      return "/3/account"
    case .favorites(_, let userId, _):
      return  "/3/account/\(userId)/favorite/tv"
    case .watchList(_, let userId, _):
      return  "/3/account/\(userId)/watchlist/tv"
    }
  }
  
  var queryParameters: [String: Any]? {
    switch self {
    case .accountDetails(let sessionId):
      return ["session_id": "\(sessionId)"]
    case .favorites(let page, _, let sessionId):
      return [
        "page": page,
        "session_id": "\(sessionId)"]
    case .watchList(let page, _, let sessionId):
      return [
        "page": page,
        "session_id": "\(sessionId)"]
    }
  }
  
  var method: ServiceMethod {
    switch self {
    case .accountDetails, .favorites, .watchList:
      return .get
    }
  }
}
