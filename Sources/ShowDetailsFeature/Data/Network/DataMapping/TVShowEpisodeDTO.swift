//
//  TVShowEpisodeDTO.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct TVShowEpisodeDTO: Decodable {
  let id: Int
  let episodeNumber: Int
  let name: String?
  let airDate: String?
  let voteAverage: Double?
  let posterPath: String?

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case episodeNumber = "episode_number"
    case name
    case airDate = "air_date"
    case voteAverage =  "vote_average"
    case posterPath = "still_path"
  }
}
