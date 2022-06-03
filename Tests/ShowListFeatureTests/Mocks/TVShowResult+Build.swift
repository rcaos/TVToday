//
//  TVShowResult+Build.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 29/03/22.
//

import CommonMocks
import Shared
import Foundation

func buildFirstPageSnapshot() -> TVShowPage {
  let firstShow = TVShowPage.TVShow.stub(
    id: 1,
    name: "Dark 🐶",
    voteAverage: 8.0,
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview")

  let secondShow = TVShowPage.TVShow.stub(
    id: 2,
    name: "Esto es un TVShow con un título muy grande creado con fines de test, This could be longer and longer, the number of lines is zero, so the row will increase its height 🚨",
    voteAverage: 9.0,
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview2")

  return TVShowPage.stub(
    page: 1,
    showsList: [firstShow, secondShow],
    totalPages: 2,
    totalShows: 3)
}

func buildSecondPageSnapshot() -> TVShowPage {
  let thirdShow = TVShowPage.TVShow.stub(
    id: 3,
    name: "Dragon Ball Z 🔫",
    voteAverage: 10.0,
    posterPath: URL(string: "mock"),
    backDropPath: URL(string: "mock"),
    overview: "overview3")

  return TVShowPage.stub(
    page: 2,
    showsList: [thirdShow],
    totalPages: 2,
    totalShows: 3)
}
