//
//  AiringTodayCollectionViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Shared

final class AiringTodayCollectionViewModel {
  
  let show: TVShow
  
  var showName: String?
  var average: String?
  
  var posterURL: URL?
  
  // MARK: - Initializers
  
  public init(show: TVShow) {
    self.show = show
    setup()
  }
  
  fileprivate func setup() {
    showName = show.name ?? ""
    
    if let average = show.voteAverage {
      self.average = String(average)
    } else {
      average = "0.0"
    }
    posterURL = show.backDropPathURL
  }
}

extension AiringTodayCollectionViewModel: Equatable {
  
  public static func == (lhs: AiringTodayCollectionViewModel, rhs: AiringTodayCollectionViewModel) -> Bool {
    return lhs.show.id == rhs.show.id
  }
}
