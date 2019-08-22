//
//  TVShow.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct TVShow: Codable{
    
    var id: Int!
    var name: String!
    var voteAverage: Double!
    var firstAirDate: String!
    var posterPath: String!
    var genreIds: [Int]!
    var backDropPath: String!
    var overview: String!
    var originCountry: [String]!
    
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
        
    }
}
