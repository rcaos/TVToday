//
//  ResultSearchSectionModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/8/20.
//

import UI

enum ResultSearchSectionModel: Hashable {
  case recentSearchs(items: [ResultSearchSectionItem])
  case results(items: [ResultSearchSectionItem])

  var section: ResultSearchSectionView {
    switch self {
    case .recentSearchs:
      return .recentSearch
    case .results:
      return .results
    }
  }

  var items: [ResultSearchSectionItem] {
    switch self {
    case let .recentSearchs(items):
      return items
    case let .results(items):
      return items
    }
  }
}

enum ResultSearchSectionView: Hashable {
  case recentSearch
  case results

  var header: String? {
    switch self {
    case .recentSearch:
      return Strings.searchResultsRecentSearchsTitle.localized()
    default:
      return nil
    }
  }
}

enum ResultSearchSectionItem: Hashable {
  case recentSearchs(items: String)
  case results(items: TVShowCellViewModel)
}
