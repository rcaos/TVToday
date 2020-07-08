//
//  ResultSearchSectionModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/8/20.
//

import RxDataSources
import Shared

enum ResultSearchSectionModel {
  case
  recentSearchs(items: [ResultSearchSectionItem]),
  results(items: [ResultSearchSectionItem])
  
  func getHeader() -> String? {
    switch self {
    case .recentSearchs:
      return "Recent Searchs"
    case .results:
      return nil
    }
  }
}

enum ResultSearchSectionItem {
  case
  recentSearchs(items: String),
  results(items: TVShowCellViewModel)
}

extension ResultSearchSectionModel: SectionModelType {
  
  typealias Item =  ResultSearchSectionItem
  
  var items: [ResultSearchSectionItem] {
    switch self {
    case .recentSearchs(items: let items):
      return items
    case .results(items: let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .recentSearchs:
      self = .recentSearchs(items: items)
    case .results:
      self = .results(items: items)
    }
  }
}
