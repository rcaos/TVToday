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
  showsVisited(items: [SearchSectionItem]),
  genres(items: [SearchSectionItem])
  
  func getHeader() -> String? {
    switch self {
    case .showsVisited:
      return "Recently TVShows Visited"
    case .genres:
      return "TVShows Genres"
    }
  }
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
    case .showsVisited(let items):
      return items
    case .genres(let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .showsVisited:
      self = .showsVisited(items: items)
    case .genres:
      self = .genres(items: items)
    }
  }
}
