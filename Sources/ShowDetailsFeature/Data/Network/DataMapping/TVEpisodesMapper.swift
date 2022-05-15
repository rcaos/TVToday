//
//  TVEpisodesMapper.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Foundation
import Shared

public class TVEpisodesMapper: TVEpisodesMapperProtocol {
  public init() { }
  
  public func mapSeasonDTO(_ season: TVShowSeasonDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowSeason {
    let episodes: [TVShowEpisode] = season.episodes.map {
      let posterPath = $0.posterPath ?? ""
      let posterPathURL = URL(string: "\(imageBasePath)/t/p/\(imageSize.rawValue)\(posterPath)")
      return TVShowEpisode(
        id: $0.id,
        episodeNumber: $0.episodeNumber,
        name: $0.name,
        airDate: $0.airDate,
        voteAverage: $0.voteAverage,
        posterPathURL: posterPathURL
      )
    }
    return TVShowSeason(id: season.id, episodes: episodes, seasonNumber: season.seasonNumber)
  }
}
