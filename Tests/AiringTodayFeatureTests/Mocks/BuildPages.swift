//
//  BuildPagesAiringToday.swift
//  
//
//  Created by Jeans Ruiz on 14/05/22.
//

import Foundation
@testable import Shared

// MARK: - For SnapshotTests
public func buildFirstPageSnapshot() -> TVShowPage {
  let firstShow = TVShowPage.TVShow.stub(
    id: 1,
    name: "The Tonight Show Starring Jimmy Fallon With Dragon Ball Z and Breaking Bad",
    voteAverage: 6.1,
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview"
  )
  return TVShowPage.stub(page: 1,
                         showsList: [firstShow],
                         totalPages: 2,
                         totalShows: 2)
}

public func buildSecondPageSnapshot() -> TVShowPage {
  let secondShow = TVShowPage.TVShow.stub(
    id: 3,
    name: "title3 🚨",  // MARk: - TODO, test a large name here
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview3"
  )
  return TVShowPage.stub(page: 2,
                         showsList: [secondShow],
                         totalPages: 2,
                         totalShows: 2)
}
