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
    
    var path: String {
        switch self {
        case .getAll:
            return "/3/genre/tv/list"
        }
    }
    
    func getParameters(with config: NetworkConfigurable) -> [String: Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .getAll:
            params["api_key"] = config.queryParameters["api_key"]
            params["language"] = config.queryParameters["language"]
        }
        return params
    }
    
    var method: ServiceMethod {
        return .get
    }
}
