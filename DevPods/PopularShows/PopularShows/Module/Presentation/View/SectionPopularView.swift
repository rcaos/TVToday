//
//  SectionPopularView.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 8/3/20.
//

import RxDataSources
import Shared

struct SectionPopularView {
  var header: String
  var items: [Item]
}

extension SectionPopularView: SectionModelType {
  
  typealias Item = TVShowCellViewModel
  
  init(original: SectionPopularView, items: [Item]) {
    self = original
    self.items = items
  }
}
