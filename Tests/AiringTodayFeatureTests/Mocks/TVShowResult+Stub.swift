//
//  TVShowResult+Stub.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

@testable import Shared

extension TVShowResult {

  static func stub(page: Int? = 1,
                   results: [TVShow],
                   totalResults: Int,
                   totalPages: Int) -> Self {

    TVShowResult(page: page,
                 results: results,
                 totalResults: totalResults,
                 totalPages: totalPages)
  }

  // MARK: - Empty
  static var empty: TVShowResult {
    return TVShowResult.stub(
      page: 1,
      results: [],
      totalResults: 0,
      totalPages: 1
    )
  }
}
