//
//  AiringTodayCollectionViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Shared

public final class AiringTodayCollectionViewModel {
  
  let show: TVShow
  
  public var showName: String?
  public var average: String?
  
  public var posterURL: URL?
  
  // MARK: - Initializers
  
  public init(show: TVShow) {
    self.show = show
    setup()
  }
  
  fileprivate func setup() {
    self.showName = show.name ?? ""
    
    if let average = show.voteAverage {
      self.average = String(average)
    } else {
      average = "0.0"
    }
    self.posterURL = show.backDropPathURL
  }
}
