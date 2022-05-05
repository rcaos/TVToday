//
//  SeasonHeaderViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Shared

public struct SeasonHeaderViewModel: Hashable {
  let showName: String

  public init(showDetail: TVShowDetail) {
    if let years = showDetail.releaseYears {
      showName = showDetail.name + " (" + years + ")"
    } else {
      showName = showDetail.name
    }
  }
}
