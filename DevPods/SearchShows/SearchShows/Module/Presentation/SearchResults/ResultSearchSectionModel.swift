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
  recentSearchs(header: String, items: [ResultSearchSectionItem]),
  results(header: String, items: [ResultSearchSectionItem])
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
    case .recentSearchs(_, items: let items):
      return items
    case .results(_, items: let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .recentSearchs(header: let header, items: _):
      self = .recentSearchs(header: header, items: items)
    case .results(header: let header, items: _):
      self = .results(header: header, items: items)
    }
  }
  
}
