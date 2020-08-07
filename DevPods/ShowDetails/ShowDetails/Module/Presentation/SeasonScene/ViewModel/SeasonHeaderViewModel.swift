//
//  SeasonHeaderViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Shared

protocol SeasonHeaderViewModelProtocol {
  
  var showName: String { get }
}

public final class SeasonHeaderViewModel: SeasonHeaderViewModelProtocol {
  
  var showName: String  = ""
  
  private let showDetail: TVShowDetailResult
  
  public init(showDetail: TVShowDetailResult) {
    self.showDetail = showDetail
    setupUI()
  }
  
  private func setupUI() {
    if let name = showDetail.name {
      showName = name
    }
    
    if let years = showDetail.releaseYears {
      showName += " (" + years + ")"
    }
  }
}
