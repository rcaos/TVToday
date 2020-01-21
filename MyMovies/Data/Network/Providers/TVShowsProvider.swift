//
//  MovieProvider.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum TVShowsProvider {
    
    case getAiringTodayShows(Int)
    case getPopularTVShows(Int)
    case getTVShowDetail(Int)
    case getEpisodesFor(Int,Int)
    case searchTVShow(String, Int)
    case listTVShowsBy(Int,Int)
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
        }
    }
    
    func getParameters(with config: NetworkConfigurable) -> [String: Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .getAiringTodayShows(let page):
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
            params["page"] = page
        case .getPopularTVShows(let page):
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
            params["page"] = page
        case .getTVShowDetail(_):
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
        case .getEpisodesFor(_, _):
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
        case .searchTVShow(let query, let page):
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
            params["query"] = query
            params["page"] = page
        case .listTVShowsBy(let genre, let page):
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
            params["with_genres"] = genre
            params["page"] = page
            params["sort_by"] = "popularity.desc"
            params["timezone"] = "America%2FNew_York"
            params["include_null_first_air_dates"] = "false"
        }
        
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
