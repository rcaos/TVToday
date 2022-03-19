//
//  TVShowCellViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct TVShowCellViewModel: Hashable {

  public let entity: TVShow

  var name: String = ""
  var average: String = ""
  var firstAirDate: String = ""
  var posterPathURL: URL?

  public init(show: TVShow) {
    self.entity = show

    name = show.name

    if let voteAverage = show.voteAverage {
      average = String(voteAverage)
    }

    if let firstAir = show.firstAirDate {
      firstAirDate = firstAir
    }

    posterPathURL = show.posterPathURL
  }
}
