//
//  SeasonResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension SeasonResult: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case _id
        case episodes
        case seasonNumber = "season_number"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._id = try container.decodeIfPresent(String.self, forKey: ._id)
        self.episodes = try container.decodeIfPresent([Episode].self, forKey: .episodes)
        self.seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
    }
}
