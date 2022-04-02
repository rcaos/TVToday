//
//  SearchViewState.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 30/03/22.
//

enum SearchViewState {
  case loading
  case populated
  case empty
  case error(String)
}

extension SearchViewState: Equatable {

  static public func == (lhs: SearchViewState, rhs: SearchViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (.populated, .populated):
      return true
    case (.empty, .empty):
      return true
    case (.error, .error):
      return true
    default:
      return false
    }
  }
}
