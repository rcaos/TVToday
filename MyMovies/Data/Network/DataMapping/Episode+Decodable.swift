//
//  Episode+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension Episode: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case episodeNumber = "episode_number"
        case name
        case airDate = "air_date"
        case voteAverage =  "vote_average"
        case episodePath = "still_path"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.airDate = try container.decodeIfPresent(String.self, forKey: .airDate)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.episodePath = try container.decodeIfPresent(String.self, forKey: .episodePath)
    }
}
