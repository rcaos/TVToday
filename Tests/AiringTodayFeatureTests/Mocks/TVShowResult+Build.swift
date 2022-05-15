//
//  TVShowResult+Build.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 29/03/22.
//

import Foundation
@testable import Shared

func buildFirstPage() -> TVShowPage {
  let firstShow = TVShowPage.TVShow.stub(
    id: 1,
    name: "title1 🐶",
    overview: "overview"
  )
  let secondShow = TVShowPage.TVShow.stub(
    id: 2,
    name: "title2 🔫",
    overview: "overview2"
  )
  return TVShowPage.stub(page: 1,
                         showsList: [firstShow, secondShow],
                         totalPages: 2,
                         totalShows: 3)
}

func buildSecondPage() -> TVShowPage {
  let thirdShow = TVShowPage.TVShow.stub(
    id: 3,
    name: "title3 🚨",
    overview: "overview3"
  )
  return TVShowPage.stub(page: 2,
                         showsList: [thirdShow],
                         totalPages: 2,
                         totalShows: 3)
}

// MARK: - For SnapshotTests
func buildFirstPageSnapshot() -> TVShowPage {
  let firstShow = TVShowPage.TVShow.stub(
    id: 1,
    name: "title1 🐶",
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview"
  )
  return TVShowPage.stub(page: 1,
                         showsList: [firstShow],
                         totalPages: 2,
                         totalShows: 2)
}

func buildSecondPageSnapshot() -> TVShowPage {
  let secondShow = TVShowPage.TVShow.stub(
    id: 3,
    name: "title3 🚨",
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview3"
  )
  return TVShowPage.stub(page: 2,
                         showsList: [secondShow],
                         totalPages: 2,
                         totalShows: 2)
}
