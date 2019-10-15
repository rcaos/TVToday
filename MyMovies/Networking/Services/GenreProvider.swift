//
//  GenreProvider.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum GenreProvider {
    case getAll
}

extension GenreProvider: EndPoint {
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .getAll:
            return "/3/genre/tv/list"
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = ["api_key": "06e1a8c1f39b7a033e2efb972625fee2"]
        
        switch self {
        case .getAll:
            params["language"] = "en-US"
        }
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
