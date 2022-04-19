//
//  SimpleViewState.swift
//  TVToday
//
//  Created by Jeans on 1/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public enum SimpleViewState<Entity: Equatable> {
  case loading
  case paging([Entity], next: Int)
  case populated([Entity])
  case empty
  case error(String)

  public var currentEntities: [Entity] {
    switch self {
    case .populated(let entities):
      return entities
    case .paging(let entities, next: _):
      return entities
    case .loading, .empty, .error:
      return []
    }
  }

  public var currentPage: Int {
    switch self {
    case .loading, .populated, .empty, .error:
      return 1
    case .paging(_, next: let page):
      return page
    }
  }

  public var isInitialPage: Bool {
    return currentPage == 1
  }
}

extension SimpleViewState: Equatable {

  static public func == (lhs: SimpleViewState<Entity>, rhs: SimpleViewState<Entity>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (let .paging(lhsShows, lNextPage), let .paging(rhsShows, rNextPage)):
      return (lhsShows == rhsShows) && (lNextPage == rNextPage)
    case (let .populated(lhShows), let .populated(rhShows)):
      return lhShows == rhShows

    case (.empty, .empty):
      return true
    case (.error, .error):
      return true

    default:
      return false
    }
  }
}
