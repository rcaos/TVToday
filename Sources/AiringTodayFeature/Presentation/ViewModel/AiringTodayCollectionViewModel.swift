//
//  AiringTodayCollectionViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Shared

struct AiringTodayCollectionViewModel: Hashable {
  private let showId: Int
  let showName: String?
  let average: String?

  let posterURL: URL?

  // MARK: - Initializers
  public init(show: TVShowPage.TVShow) {
    showId = show.id
    showName = show.name
    if show.voteAverage == 0 {
      average = String(show.voteAverage)
    } else {
      average = "0.0"
    }
    posterURL = show.backDropPath
  }
}

enum SectionAiringTodayFeed: Hashable {
  case shows
}
