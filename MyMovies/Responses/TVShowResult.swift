//
//  TVShowResult.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct TVShowResult: Codable{
    let page: Int!
    let results: [TVShow]!
    let totalResults: Int!
    let totalPages: Int!
    
    enum CodingKeys: String, CodingKey{
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
