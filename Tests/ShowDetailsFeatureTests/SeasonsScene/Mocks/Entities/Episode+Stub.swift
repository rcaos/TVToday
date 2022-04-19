//
//  Episode+Stub.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

@testable import ShowDetailsFeature

extension Episode {

  public static func stub(id: Int = 1,
                          episodeNumber: Int = 1,
                          name: String = "Name 1",
                          airDate: String =  "01/01/1990",
                          voteAverage: Double = 1.0,
                          posterPath: String? = nil
  ) -> Self {
    Episode(id: id,
            episodeNumber: episodeNumber,
            name: name,
            airDate: airDate,
            voteAverage: voteAverage,
            posterPath: posterPath)
  }
}
