//
//  Episode.swift
//  MyTvShows
//
//  Created by Jeans on 9/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct Episode: Codable{
    
    var episodeNumber: Int!
    var name: String!
    var airDate: String!
    var voteAverage: Double!
    var episodePath: String!
    
    enum CodingKeys: String, CodingKey{
        case episodeNumber = "episode_number"
        case name
        case airDate = "air_date"
        case voteAverage =  "vote_average"
        case episodePath = "still_path"
    }
}

extension Episode{
    var average: String{
        if let voteAverage = self.voteAverage{
            return String(format: "%.1f", voteAverage)
        }
        return ""
    }
}
