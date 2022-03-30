//
//  TVShowResult+Build.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 29/03/22.
//

import Shared

func buildFirstPage() -> TVShowResult {
  let firstShow = TVShow.stub(id: 1,
                              name: "Dark 🐶",
                              voteAverage: 8.0,
                              posterPath: "/1",
                              backDropPath: "/back1",
                              overview: "overview")
  let secondShow = TVShow.stub(id: 2,
                               name: "Dragon Ball Z 🔫",
                               voteAverage: 9.0,
                               posterPath: "/2",
                               backDropPath: "/back2",
                               overview: "overview2")

  return TVShowResult.stub(page: 1,
                           results: [firstShow, secondShow],
                           totalResults: 3,
                           totalPages: 2)
}

func buildSecondPage() -> TVShowResult {
  let thirdShow = TVShow.stub(id: 3,
                              name: "Esto es un TVShow con un título muy grande creado con fines de test 🚨",
                              voteAverage: 10.0,
                              posterPath: "/3",
                              backDropPath: "/back3",
                              overview: "overview3")

  return TVShowResult.stub(page: 2,
                           results: [thirdShow],
                           totalResults: 3,
                           totalPages: 2)
}
