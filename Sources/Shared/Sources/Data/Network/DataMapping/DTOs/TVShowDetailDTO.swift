//
//  TVShowDetailDTO.swift
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct TVShowDetailDTO: Decodable {

  public let id: Int
  public let name: String
  public let firstAirDate: String?
  public let lastAirDate: String?
  public let episodeRunTime: [Int]?
  public let genreIds: [GenreDTO]?
  public let numberOfEpisodes: Int?
  public let numberOfSeasons: Int?

  public var posterPath: String?
  public var backDropPath: String?
  public let overview: String?

  public let voteAverage: Double?
  public let voteCount: Int?

  public let status: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case firstAirDate = "first_air_date"
    case lastAirDate = "last_air_date"
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
}
