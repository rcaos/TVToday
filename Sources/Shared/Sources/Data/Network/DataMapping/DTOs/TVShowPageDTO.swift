//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 3/05/22.
//

import Foundation

public struct TVShowPageDTO: Decodable {
  public let page: Int
  public let showsList: [TVShow2DTO]
  public let totalPages: Int
  public let totalShows: Int

  enum CodingKeys: String, CodingKey {
    case page
    case showsList = "results"
    case totalPages = "total_pages"
    case totalShows = "total_results"
  }
}

public struct TVShow2DTO: Decodable {
  public let id: Int  // 52698
  public let name: String // "El Kabeer"
  public let overview: String // "lorep ipsum ...."
  public let firstAirDate: String? // "2010-08-11"
  public let posterPath: String? //    "/Ap86RyRhP7ikeRCpysnfC9PO2H0.jpg"
  public let backDropPath: String? //  "/5dJccl3yF1Er6HVZDceYZC3rzhh.jpg"
  public let genreIds: [Int]?  // [35]
  public let voteAverage: Double // 7.3
  public let voteCount: Int // 14

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case overview
    case firstAirDate = "first_air_date"
    case posterPath = "poster_path"
    case backDropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
}
