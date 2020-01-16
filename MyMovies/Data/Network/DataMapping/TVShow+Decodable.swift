//
//  TVShow+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension TVShow: Decodable {
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case backDropPath = "backdrop_path"
        case overview
        case originCountry = "origin_country"
        case voteCount = "vote_count"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
        
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
        self.backDropPath = try container.decodeIfPresent(String.self, forKey: .backDropPath)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.originCountry = try container.decode([String].self, forKey: .originCountry)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}
