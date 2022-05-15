//
//  MappingHelpers.swift
//  
//
//  Created by Jeans Ruiz on 14/05/22.
//

import Foundation
@testable import Shared

public func buildFirstPage() -> TVShowPage {
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

public func buildSecondPage() -> TVShowPage {
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
