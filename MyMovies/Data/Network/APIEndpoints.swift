//
//  APIEndpoints.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct APIEndpoints {
    
    static func todayTVShows(page: Int) -> Endpoint<TVShowResult> {
        
        return Endpoint(path: "3/tv/airing_today",
                        queryParameters: ["page": "\(page)"])
    }
}
