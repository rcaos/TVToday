//
//  TVShowEpisode.swift
//  MyTvShows
//
//  Created by Jeans on 9/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct TVShowEpisode {
  let id: Int
  let episodeNumber: Int
  let name: String?
  let airDate: String?
  let voteAverage: Double?
  let posterPathURL: URL?
}

extension TVShowEpisode {
  public var average: String {
    if let voteAverage = self.voteAverage {
      return String(format: "%.1f", voteAverage)
    }
    return ""
  }
}
