//
//  TVShowCellViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public final class TVShowCellViewModel {
  
  public let entity: TVShow
  
  var name: String?
  var average: String?
  
  public init(show: TVShow) {
    self.entity = show

    name = show.name

    if let voteAverage = show.voteAverage {
      average = String(voteAverage)
    } else {
      average = ""
    }
  }
}
