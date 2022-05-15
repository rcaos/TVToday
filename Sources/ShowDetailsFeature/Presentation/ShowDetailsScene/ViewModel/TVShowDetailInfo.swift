//
//  TVShowDetailInfo.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Foundation
import Shared

public struct TVShowDetailInfo {
  var id: Int
  var backDropPath: URL?
  var nameShow: String?
  var yearsRelease: String?
  var duration: String?
  var genre: String?
  var numberOfEpisodes: String?
  var posterPath: URL?
  var overView: String?
  var score: String?
  var maxScore: String = "/10"
  var countVote: String?

  public init(show: TVShowDetail) {
    id = show.id
    backDropPath = show.backDropPathURL
    nameShow = show.name
    yearsRelease = show.releaseYears
    duration = show.episodeDuration
    genre = show.genreIds.first?.name
    numberOfEpisodes = String(show.numberOfEpisodes)
    posterPath = show.posterPathURL
    overView = show.overview
    score = String(show.voteAverage)
    countVote = String(show.voteCount)
  }
}
