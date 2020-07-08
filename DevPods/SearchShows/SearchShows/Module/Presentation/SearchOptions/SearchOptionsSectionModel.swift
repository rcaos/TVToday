//
//  SearchOptionsSectionModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/8/20.
//

import RxDataSources
import Persistence
import Shared

enum SearchOptionsSectionModel {
  case
  showsVisited(header: String, items: [SearchSectionItem]),
  genres(header: String, items: [SearchSectionItem])
}

enum SearchSectionItem {
  case
  showsVisited(items: [ShowVisited]),
  genres(items: Genre)
}

extension SearchOptionsSectionModel: SectionModelType {
  typealias Item = SearchSectionItem
  
  var items: [SearchSectionItem] {
    switch self {
    case .showsVisited(_, items: let items):
      return items
    case .genres(_, items: let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .showsVisited(header: let header, items: _):
      self = .showsVisited(header: header, items: items)
    case .genres(header: let header, items: _):
      self = .genres(header: header, items: items)
    }
  }
}
