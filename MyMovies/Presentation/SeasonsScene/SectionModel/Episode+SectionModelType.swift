//
//  Episode+SectionModelType.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/30/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxDataSources

public struct EpisodeSectionModelType {
  
  var id: Int
  var episodeNumber: Int
  var name: String?
  var airDate: String?
  var voteAverage: Double?
  var episodePath: String?
  
  init(episode: Episode) {
    self.id = episode.id
    self.episodeNumber = episode.episodeNumber
    self.name = episode.name
    self.airDate = episode.airDate
    self.voteAverage = episode.voteAverage
    self.episodePath = episode.episodePath
  }
  
  static func buildEpisode(from episodeSection: EpisodeSectionModelType) -> Episode {
    return Episode(id: episodeSection.id,
                   episodeNumber: episodeSection.episodeNumber,
                   name: episodeSection.name,
                   airDate: episodeSection.airDate,
                   voteAverage: episodeSection.voteAverage,
                   episodePath: episodeSection.episodePath)
  }
}

// MARK: - RxDataSource Animated

extension EpisodeSectionModelType: IdentifiableType {
  public typealias Identity = Int
  
  public var identity: Int {
    return id
  }
}

extension EpisodeSectionModelType: Equatable {
  
  static public func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}
