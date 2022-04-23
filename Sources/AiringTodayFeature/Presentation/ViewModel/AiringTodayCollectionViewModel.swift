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
  let show: TVShow

  var showName: String?
  var average: String?

  var posterURL: URL?

  // MARK: - Initializers
  public init(show: TVShow) {
    self.show = show

    showName = show.name ?? ""
    if let average = show.voteAverage {
      self.average = String(average)
    } else {
      average = "0.0"
    }
    posterURL = show.backDropPathURL
  }
}

enum SectionAiringTodayFeed: Hashable {
  case shows
}
