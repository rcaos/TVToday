//
//  TVShowResult+Build.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 29/03/22.
//

import Foundation
@testable import Shared

func buildFirstPage() -> TVShowResult {
  let firstShow = TVShow.stub(
    id: 1,
    name: "title1 🐶",
    posterPath: "/1",
    backDropPath: "/back1",
    overview: "overview"
  )
  let secondShow = TVShow.stub(
    id: 2,
    name: "title2 🔫",
    posterPath: "/2",
    backDropPath: "/back2",
    overview: "overview2"
  )
  return TVShowResult.stub(page: 1,
                           results: [firstShow, secondShow],
                           totalResults: 3,
                           totalPages: 2)
}

func buildSecondPage() -> TVShowResult {
  let thirdShow = TVShow.stub(
    id: 3,
    name: "title3 🚨",
    posterPath: "/3",
    backDropPath: "/back3",
    overview: "overview3"
  )
  return TVShowResult.stub(page: 2,
                           results: [thirdShow],
                           totalResults: 3,
                           totalPages: 2)
}

// MARK: - For SnapshotTests
func buildFirstPageSnapshot() -> TVShowResult {
  let firstShow = TVShow.stub(
    id: 1,
    name: "title1 🐶",
    posterPath: "/1",
    backDropPath: "/back1",
    overview: "overview"
  )
  return TVShowResult.stub(page: 1,
                           results: [firstShow],
                           totalResults: 2,
                           totalPages: 2)
}

func buildSecondPageSnapshot() -> TVShowResult {
  let secondShow = TVShow.stub(
    id: 3,
    name: "title3 🚨",
    posterPath: "/3",
    backDropPath: "/back3",
    overview: "overview3"
  )
  return TVShowResult.stub(page: 2,
                           results: [secondShow],
                           totalResults: 2,
                           totalPages: 2)
}
