//
//  SeasonResult.swift
//  MyTvShows
//
//  Created by Jeans on 9/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct SeasonResult: Codable{
    let _id: String!
    let episodes: [Episode]!
    let seasonNumber: Int!
    
    enum CodingKeys: String, CodingKey{
        case _id
        case episodes
        case seasonNumber = "season_number"
    }
}
