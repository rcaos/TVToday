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
  var episodePath: String?
}

extension Episode {
  
  var average: String {
    if let voteAverage = self.voteAverage {
      return String(format: "%.1f", voteAverage)
    }
    return ""
  }
}

extension Episode {
  
  // MARK: - TODO inject Base
  public func getposterPathURL(base: String = "https://image.tmdb.org/t/p/w342") -> URL? {
    guard let urlString = episodePath else { return nil }
    return URL(string: "\(base)\(urlString)")
  }
}
