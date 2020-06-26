//
//  MovieProvider.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Networking

enum TVShowsProvider {
  
  case getAiringTodayShows(Int)
  case getPopularTVShows(Int)
  case getTVShowDetail(Int)
  case getEpisodesFor(Int, Int)
  case searchTVShow(String, Int)
  case listTVShowsBy(Int, Int)
  case getAccountStates(tvShowId: Int, sessionId: String)
}

extension TVShowsProvider: EndPoint {
  
  var path: String {
    switch self {
    case .getAiringTodayShows:
      return "/3/tv/airing_today"
    case .getPopularTVShows:
      return "/3/tv/popular"
    case .getTVShowDetail(let identifier):
      return "/3/tv/\(identifier)"
    case .getEpisodesFor(let show, let season):
      return "/3/tv/\(show)/season/\(season)"
    case .searchTVShow:
      return "/3/search/tv"
    case .listTVShowsBy:
      return "/3/discover/tv"
    case .getAccountStates(let tvShowId, _):
      return "/3/tv/\(String(tvShowId))/account_states"
      
    }
  }
  
  var queryParameters: [String: Any]? {
    var parameters: [String: Any] = [:]
    
    switch self {
    case .getAiringTodayShows(let page):
      parameters["page"] = page
    case .getPopularTVShows(let page):
      parameters["page"] = page
    case .getTVShowDetail:
      break
    case .getEpisodesFor:
      break
    case .searchTVShow(let query, let page):
      parameters["query"] = query
      parameters["page"] = page
    case .listTVShowsBy(let genre, let page):
      parameters["with_genres"] = genre
      parameters["page"] = page
      parameters["sort_by"] = "popularity.desc"
      parameters["timezone"] = "America%2FNew_York"
      parameters["include_null_first_air_dates"] = "false"
    case .getAccountStates(_, let sessionId):
      parameters["session_id"] = sessionId
    }
    return parameters
  }
  
  var method: ServiceMethod {
    return .get
  }
  
  var parameterEncoding: ParameterEnconding {
    return .defaultEncoding
  }
}
