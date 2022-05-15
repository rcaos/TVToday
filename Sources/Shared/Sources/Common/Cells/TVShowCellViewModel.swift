//
//  TVShowCellViewModel.swift
//  Shared
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct TVShowCellViewModel: Hashable {
  private let showId: Int
  let name: String
  let average: String
  let firstAirDate: String
  let posterPathURL: URL?

  public init(show: TVShowPage.TVShow) {
    showId = show.id
    name = show.name
    average = (show.voteAverage == 0) ? "0.0": String(show.voteAverage)
    firstAirDate = show.firstAirDate
    posterPathURL = show.posterPath
  }
}
