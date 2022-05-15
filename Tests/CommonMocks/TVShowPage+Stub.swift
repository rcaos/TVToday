//
//  TVShowPage+Stub.swift
//  
//
//  Created by Jeans Ruiz on 14/05/22.
//

@testable import Shared

extension TVShowPage {
  public static func stub(page: Int = 1,
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
  public static var empty: TVShowPage {
    return TVShowPage.stub(
      page: 1,
      showsList: [],
      totalPages: 0,
      totalShows: 1
    )
  }
}
