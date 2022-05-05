//
//  TVShowDetail.swift
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct TVShowDetail: Hashable {
  public let id: Int
  public let name: String
  public let firstAirDate: String
  public let lastAirDate: String
  public let episodeRunTime: [Int]
  public let genreIds: [Genre]
  public let numberOfEpisodes: Int
  public let numberOfSeasons: Int

  public var posterPathURL: URL?
  public var backDropPathURL: URL?
  public let overview: String

  public let voteAverage: Double
  public let voteCount: Int

  public let status: String

  public var releaseYears: String? {
    let yearIni = getYear(from: firstAirDate)

    var yearEnd = ""
    if status == "Ended"{
      yearEnd = getYear(from: lastAirDate)
    } else {
      yearEnd = ""
    }

    return yearIni + " - " + yearEnd
  }

  public var episodeDuration: String? {
    var duration = ""
    if let runTime = episodeRunTime.first {
      duration = "\(String(runTime))"
    } else {
      duration = "?"
    }
    return "\(duration) min"
  }

  // MARK: - Helper for Dates
  private func getYear(from dateString: String?) -> String {
    guard let dateString = dateString else {
      return "?"
    }

    // https://stackoverflow.com/a/41023135/11964677
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "America/New_York")
    formatter.dateFormat = "yyyy-MM-dd"

    if let date = formatter.date(from: dateString) {
      formatter.dateFormat = "yyyy"
      let yearString = formatter.string(from: date)
      return yearString
    } else {
      return "?"
    }
  }
}
