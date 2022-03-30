//
//  TVShowResult+Build.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 29/03/22.
//

import Foundation
@testable import Shared

public func makeFirstPage() -> TVShowResult {
  let firstShow = TVShow.stub(id: 1, name: "title1 🐶", posterPath: "/1",
                              backDropPath: "/back1", overview: "overview")
  return TVShowResult.stub(page: 1,
                           results: [firstShow],
                           totalResults: 3,
                           totalPages: 2)
}

public func makeSecondPage() -> TVShowResult {
  let thirdShow = TVShow.stub(id: 3, name: "title3 🚨", posterPath: "/3",
                              backDropPath: "/back3", overview: "overview3")
  return TVShowResult.stub(page: 2,
                           results: [thirdShow],
                           totalResults: 3,
                           totalPages: 2)
}
