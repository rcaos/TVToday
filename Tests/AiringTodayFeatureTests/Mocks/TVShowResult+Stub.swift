//
//  TVShowResult+Stub.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

@testable import Shared

extension TVShowPage {

  static func stub(page: Int = 1,
                   showsList: [TVShow],
                   totalPages: Int,
                   totalShows: Int) -> Self {
    TVShowPage(
      page: page,
      showsList: showsList,
      totalPages: totalPages,
      totalShows: totalShows
    )
  }

  // MARK: - Empty
  static var empty: TVShowPage {
    return TVShowPage.stub(
      page: 1,
      showsList: [],
      totalPages: 0,
      totalShows: 1
    )
  }
}
