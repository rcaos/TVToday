//
//  AccountShowsProvider.swift
//  Shared
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import Networking

enum AccountShowsProvider {
  case favorites(page: Int, userId: String, sessionId: String)
  case watchList(page: Int, userId: String, sessionId: String)
  case getAccountStates(tvShowId: Int, sessionId: String)
  case markAsFavorite(userId: String, tvShowId: Int, sessionId: String, favorite: Bool)
  case savetoWatchList(userId: String, tvShowId: Int, sessionId: String, watchList: Bool)
}

extension AccountShowsProvider: EndPoint {

  var path: String {
    switch self {
    case .favorites(_, let userId, _):
      return  "/3/account/\(userId)/favorite/tv"
    case .watchList(_, let userId, _):
      return  "/3/account/\(userId)/watchlist/tv"
    case .getAccountStates(let tvShowId, _):
      return "/3/tv/\(String(tvShowId))/account_states"
    case .markAsFavorite(let userId, _, _, _):
      return "/3/account/\(userId)/favorite"
    case .savetoWatchList(let userId, _, _, _):
      return "/3/account/\(userId)/watchlist"
    }
  }

  var queryParameters: [String: Any]? {
    switch self {
    case .favorites(let page, _, let sessionId):
      return [
        "page": page,
        "session_id": "\(sessionId)"]
    case .watchList(let page, _, let sessionId):
      return [
        "page": page,
        "session_id": "\(sessionId)"]
    case .getAccountStates(_, let sessionId):
      return ["session_id": "\(sessionId)"]
    case .markAsFavorite(_, let tvShowId, let sessionId, let favorite):
      let queryParams: [String: Any] = ["session_id": "\(sessionId)"]
      let bodyParams: [String: Any] = [
        "media_type": "tv",
        "media_id": tvShowId,
        "favorite": favorite]
      return ["query": queryParams, "body": bodyParams]
    case .savetoWatchList(_, let tvShowId, let sessionId, let watchList):
      let queryParams: [String: Any] = ["session_id": "\(sessionId)"]
      let bodyParams: [String: Any] = [
        "media_type": "tv",
        "media_id": tvShowId,
        "watchlist": watchList]
      return ["query": queryParams, "body": bodyParams]
    }
  }

  var method: ServiceMethod {
    switch self {
    case .favorites, .watchList, .getAccountStates:
      return .get
    case .markAsFavorite, .savetoWatchList:
      return .post
    }
  }

  var parameterEncoding: ParameterEnconding {
    switch self {
    case .favorites, .watchList, .getAccountStates:
      return .defaultEncoding
    case .markAsFavorite, .savetoWatchList:
      return .compositeEncoding
    }
  }
}
