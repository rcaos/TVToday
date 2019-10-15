//
//  MovieProvider.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum TVShowsProvider {
    case getPopularTVShows
    case getAiringTodayShows
    case getTVShowDetail(Int)
    case getEpisodesFor(Int,Int)
    case searchTVShow(String)
    case listTVShowsBy(Int)
}

extension TVShowsProvider: EndPoint {
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .getPopularTVShows:
            return "/3/tv/popular"
        case .getAiringTodayShows:
            return "/3/tv/airing_today"
        case .getTVShowDetail(let identifier):
            return "/3/tv/\(identifier)"
        case .getEpisodesFor(let show, let season):
            return "/3/tv/\(show)/season/\(season)"
        case .searchTVShow(_):
            return "/3/search/tv"
        case .listTVShowsBy(_):
            return "/3/discover/tv"
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = ["api_key": "06e1a8c1f39b7a033e2efb972625fee2"]
        
        switch self {
        case .getPopularTVShows:
            params["language"] = "en-US"
            params["page"] = "1"
        case .getAiringTodayShows:
            params["language"] = "en-US"
            params["page"] = "1"
        case .getTVShowDetail(_):
            params["language"] = "en-US"
        case .getEpisodesFor(_, _):
            params["language"] = "en-US"
        case .searchTVShow(let query):
            params["language"] = "en-US"
            params["query"] = query
            params["page"] = "1"
        case .listTVShowsBy(let genre):
            params["language"] = "en-US"
            params["with_genre"] = "\(String(genre))"
            params["sort_by"] = "popularity.desc"
            params["page"] = "1"
            params["timezone"] = "America%2FNew_York"
            params["include_null_first_air_dates"] = "false"
        }
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
