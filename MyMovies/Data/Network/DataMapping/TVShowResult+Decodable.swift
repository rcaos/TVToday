//
//  TVShowResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension TVShowResult: Decodable {
    
    enum CodingKeys: String, CodingKey{
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.page = try container.decode(Int.self, forKey: .page)
        self.results = try container.decode([TVShow].self, forKey: .results)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
    }
}
