//
//  SeasonsSectionModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/31/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

enum SeasonsSectionModel: Hashable {
  case headerShow(items: [SeasonsSectionItem])
  case seasons(items: [SeasonsSectionItem])
  case episodes(items: [SeasonsSectionItem])

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
    case let .headerShow(items):
      return items
    case let .seasons(items):
      return items
    case let .episodes(items):
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
  case seasons
  case episodes(items: EpisodeSectionModelType)
}
