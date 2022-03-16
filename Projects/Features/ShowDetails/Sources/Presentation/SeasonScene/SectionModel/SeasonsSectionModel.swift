//
//  SeasonsSectionModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/31/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

enum SeasonsSectionModel: Hashable {
  case headerShow(header: String, items: [SeasonsSectionItem])
  case seasons(header: String, items: [SeasonsSectionItem])
  case episodes(header: String, items: [SeasonsSectionItem])

  var sectionCollection: SeasonsSectionCollection {
    switch self {
    case .headerShow:
      return .headerShow
    case .seasons:
      return .seasons
    case .episodes:
      return .episodes
    }
  }

  var items: [SeasonsSectionItem] {
    switch self {
    case let .headerShow(_, items):
      return items
    case let .seasons(_, items):
      return items
    case let .episodes(_, items):
      return items
    }
  }
}

enum SeasonsSectionCollection: Hashable {
  case headerShow
  case seasons
  case episodes
}

enum SeasonsSectionItem: Hashable {
  case headerShow(viewModel: SeasonHeaderViewModel)
  case seasons(number: Int)
  case episodes(items: EpisodeSectionModelType)
}
