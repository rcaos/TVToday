//
//  AccountProvider.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking

// MARK: - TODO, remove favorites and watchList

enum AccountProvider {
  case accountDetails(sessionId: String)
  
//  case favorites(page: Int, userId: String, sessionId: String)
//
//  case watchList(page: Int, userId: String, sessionId: String)
  
//  case markAsFavorite(userId: String, tvShowId: Int, sessionId: String, favorite: Bool)
//
//  case savetoWatchList(userId: String, tvShowId: Int, sessionId: String, watchList: Bool)
}

extension AccountProvider: EndPoint {
  
  var path: String {
    switch self {
    case .accountDetails:
      return "/3/account"
//    case .favorites(_, let userId, _):
//      return  "/3/account/\(userId)/favorite/tv"
//    case .watchList(_, let userId, _):
//      return  "/3/account/\(userId)/watchlist/tv"
//    case .markAsFavorite(let userId, _, _, _):
//      return "/3/account/\(userId)/favorite"
//    case .savetoWatchList(let userId, _, _, _):
//      return "/3/account/\(userId)/watchlist"
    }
  }
  
  var queryParameters: [String: Any]? {
    switch self {
    case .accountDetails(let sessionId):
      return ["session_id": "\(sessionId)"]
//    case .favorites(let page, _, let sessionId):
//      return [
//        "page": page,
//        "session_id": "\(sessionId)"]
//    case .watchList(let page, _, let sessionId):
//      return [
//        "page": page,
//        "session_id": "\(sessionId)"]
//    case .markAsFavorite(_, let tvShowId, let sessionId, let favorite):
//      let queryParams: [String: Any] = ["session_id": "\(sessionId)"]
//      let bodyParams: [String: Any] = [
//        "media_type": "tv",
//        "media_id": tvShowId,
//        "favorite": favorite]
//      return ["query": queryParams, "body": bodyParams]
//    case .savetoWatchList(_, let tvShowId, let sessionId, let watchList):
//      let queryParams: [String: Any] = ["session_id": "\(sessionId)"]
//      let bodyParams: [String: Any] = [
//        "media_type": "tv",
//        "media_id": tvShowId,
//        "watchlist": watchList]
//      return ["query": queryParams, "body": bodyParams]
    }
  }
  
  var method: ServiceMethod {
    switch self {
//    case .accountDetails, .favorites, .watchList:
    case .accountDetails:
      return .get
//    case .markAsFavorite, .savetoWatchList:
//      return .post
    }
  }
  
  var parameterEncoding: ParameterEnconding {
    switch self {
    case .accountDetails: //, .favorites, .watchList:
      return .defaultEncoding
//    case .markAsFavorite, .savetoWatchList:
//      return .compositeEncoding
    }
  }
}
