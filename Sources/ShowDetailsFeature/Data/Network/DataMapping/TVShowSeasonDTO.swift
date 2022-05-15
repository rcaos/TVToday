//
//  TVShowSeasonDTO.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct TVShowSeasonDTO: Decodable {
  let id: String
  let episodes: [TVShowEpisodeDTO]
  let seasonNumber: Int

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case episodes
    case seasonNumber = "season_number"
  }
}
