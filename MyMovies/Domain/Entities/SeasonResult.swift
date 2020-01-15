//
//  SeasonResult.swift
//  MyTvShows
//
//  Created by Jeans on 9/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct SeasonResult {
    
    let _id: String!
    let episodes: [Episode]!
    let seasonNumber: Int!
}

// MARK: - TODO Mover a Data Layer

extension SeasonResult: Codable {
    
    enum CodingKeys: String, CodingKey{
        case _id
        case episodes
        case seasonNumber = "season_number"
    }
}
