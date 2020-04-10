//
//  Episode.swift
//  MyTvShows
//
//  Created by Jeans on 9/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct Episode {
  
  var id: Int
  var episodeNumber: Int
  var name: String?
  var airDate: String?
  var voteAverage: Double?
  var posterPath: String?
}

extension Episode {
  
  public var average: String {
    if let voteAverage = self.voteAverage {
      return String(format: "%.1f", voteAverage)
    }
    return ""
  }
  
  public var posterPathURL: URL? {
    guard let urlString = posterPath else { return nil}
    return URL(string: urlString)
  }
}
