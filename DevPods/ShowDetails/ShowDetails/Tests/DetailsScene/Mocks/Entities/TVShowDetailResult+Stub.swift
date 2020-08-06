//
//  TVShowDetailResult+Stub.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

@testable import Shared
@testable import ShowDetails

extension TVShowDetailResult {
  
  static func stub() -> Self {
    return TVShowDetailResult(id: 1,
                              name: "Dragon Ball Z",
                              firstAirDate: "1989-04-26",
                              lasttAirDate: "1996-01-31",
                              episodeRunTime: [26],
                              genreIds: [Genre(id: 10765, name: "Sci-Fi & Fantasy")],
                              numberOfEpisodes: 291,
                              numberOfSeasons: 9,
                              posterPath: nil,
                              backDropPath: nil,
                              overview: "Five years have passed since the fight with Piccolo Jr., and Goku now has a son, Gohan. The peace is interrupted when an alien named Raditz arrives on Earth in a spacecraft and tracks down Goku, revealing to him that that they are members of a near-extinct warrior race called the Saiyans.",
                              voteAverage: 8.1,
                              voteCount: 1147,
                              status: "Ended")
  }
}
