//
//  TVShowDetail.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct TVShowDetail: Codable{
    
    var id: Int!
    var name: String!
    var firstAirDate: String!
    var lasttAirDate: String!
    var episodeRunTime: [Int]!
    var genreIds: [Genre]!
    var numberOfEpisodes:Int!
    
    var posterPath: String!
    var backDropPath: String!
    var overview: String!
    
    var voteAverage: Double!
    var voteCount: Int!
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case firstAirDate = "first_air_date"
        case lasttAirDate = "last_air_date"
        case episodeRunTime = "episode_run_time"
        case genreIds = "genres"
        case numberOfEpisodes = "number_of_episodes"
        
        case posterPath = "poster_path"
        case backDropPath = "backdrop_path"
        case overview
        
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
