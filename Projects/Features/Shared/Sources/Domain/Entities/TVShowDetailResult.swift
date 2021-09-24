//
//  TVShowDetail.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct TVShowDetailResult {
  
  public let id: Int!
  public let name: String!
  public let firstAirDate: String?
  public let lastAirDate: String?
  public let episodeRunTime: [Int]?
  public let genreIds: [Genre]?
  public let numberOfEpisodes: Int?
  public let numberOfSeasons: Int?
  
  public var posterPath: String?
  public var backDropPath: String?
  public let overview: String!
  
  public let voteAverage: Double?
  public let voteCount: Int?
  
  public let status: String?
}

extension TVShowDetailResult {
  
  // MARK: - Computed
  
  public var releaseYears: String? {
    let yearIni = getYear(from: firstAirDate)
    
    var yearEnd = ""
    if let status = status, status == "Ended"{
      yearEnd = getYear(from: lastAirDate)
    } else {
      yearEnd = ""
    }
    
    return yearIni + " - " + yearEnd
  }
  
  public var episodeDuration: String? {
    var duration = ""
    if let runTime = episodeRunTime?.first {
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
    
    let formatter = DateFormatter()
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

extension TVShowDetailResult {
  
  public var posterPathURL: URL? {
    guard let urlString = posterPath else { return nil}
    return URL(string: urlString)
  }
  
  public var backDropPathURL: URL? {
    guard let urlString = backDropPath else { return nil}
    return URL(string: urlString)
  }
}
