//
//  VisitedShowSectionModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/8/20.
//

import RxDataSources
import Persistence

struct VisitedShowSectionModel {
  var header: String
  var items: [Item]
}

extension VisitedShowSectionModel: SectionModelType {
  typealias Item = ShowVisited

  init(original: VisitedShowSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}
