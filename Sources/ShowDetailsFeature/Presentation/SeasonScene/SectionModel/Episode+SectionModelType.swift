//
//  Episode+SectionModelType.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/30/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

public struct EpisodeSectionModelType: Hashable {

  var id: Int
  var episodeNumber: Int
  var name: String?
  var airDate: String?
  var voteAverage: Double?
  var posterPath: String?

  init(episode: Episode) {
    self.id = episode.id
    self.episodeNumber = episode.episodeNumber
    self.name = episode.name
    self.airDate = episode.airDate
    self.voteAverage = episode.voteAverage
    self.posterPath = episode.posterPath
  }

  static func buildEpisode(from episodeSection: EpisodeSectionModelType) -> Episode {
    return Episode(id: episodeSection.id,
                   episodeNumber: episodeSection.episodeNumber,
                   name: episodeSection.name,
                   airDate: episodeSection.airDate,
                   voteAverage: episodeSection.voteAverage,
                   posterPath: episodeSection.posterPath)
  }
}
