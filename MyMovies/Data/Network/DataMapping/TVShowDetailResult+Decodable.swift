//
//  TVShowDetailResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension TVShowDetailResult: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstAirDate = "first_air_date"
        case lasttAirDate = "last_air_date"
        case episodeRunTime = "episode_run_time"
        case genreIds = "genres"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        
        case posterPath = "poster_path"
        case backDropPath = "backdrop_path"
        case overview
        
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
        case status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.firstAirDate = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        self.lasttAirDate = try container.decodeIfPresent(String.self, forKey: .lasttAirDate)
        self.episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
        self.genreIds = try container.decodeIfPresent([Genre].self, forKey: .genreIds)
        self.numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        self.numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.backDropPath = try container.decodeIfPresent(String.self, forKey: .backDropPath)
        self.overview = try container.decode(String.self, forKey: .overview)
        
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}
