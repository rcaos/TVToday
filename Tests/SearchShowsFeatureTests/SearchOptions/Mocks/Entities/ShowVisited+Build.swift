//
//  ShowVisited+Build.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 30/03/22.
//

import Persistence
import Shared

func buildShowVisited() -> [ShowVisited] {
  return [
    ShowVisited.stub(id: 1, pathImage: ""),
    ShowVisited.stub(id: 2, pathImage: ""),
    ShowVisited.stub(id: 3, pathImage: "")
  ]
}

func buildGenres() -> [Genre] {
  return [
    Genre.stub(id: 1, name: "Genre 1"),
    Genre.stub(id: 2, name: "Genre with a long name to show how the cell could increase its height")
  ]
}
