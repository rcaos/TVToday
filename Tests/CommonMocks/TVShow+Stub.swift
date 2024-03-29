//
//  TVShow+Stub.swift
//  
//
//  Created by Jeans Ruiz on 14/05/22.
//

import Foundation

@testable import Shared

extension TVShowPage.TVShow {
  public static func stub(
    id: Int = 1,
    name: String = "title1",
    voteAverage: Double = 1.0,
    posterPath: URL? = nil,
    backDropPath: URL? = nil,
    overview: String = "overview1"
  ) -> Self {

    TVShowPage.TVShow(
      id: id,
      name: name,
      overview: overview,
      firstAirDate: "",
      posterPath: posterPath,
      backDropPath: backDropPath,
      genreIds: [],
      voteAverage: voteAverage,
      voteCount: 0
    )
  }
}
