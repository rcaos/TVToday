//
//  SectionTVShowListView.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/3/20.
//

import RxDataSources
import Shared

struct SectionTVShowListView {
  var header: String
  var items: [Item]
}

extension SectionTVShowListView: SectionModelType {
  typealias Item = TVShowCellViewModel

  init(original: SectionTVShowListView, items: [Item]) {
    self = original
    self.items = items
  }
}
