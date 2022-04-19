//
//  GenreViewModel+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

@testable import SearchShows
@testable import Shared
@testable import Persistence

extension GenreViewModel {
  static var mock: (Genre) -> GenreViewModel = { genre in
    return GenreViewModel(genre: genre)
  }
}

extension VisitedShowViewModel {
  static var mock: ([ShowVisited]) -> VisitedShowViewModel = { shows in
    return VisitedShowViewModel(shows: shows)
  }
}
