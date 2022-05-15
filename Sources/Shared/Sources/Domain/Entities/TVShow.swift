//
//  TVShow.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

// MARK: - TODO, remove forces unwrapping here

public struct TVShow: Hashable {

  public var id: Int!
  public var name: String!
  public var voteAverage: Double!
  public var firstAirDate: String?

  public var posterPath: String?
  public var genreIds: [Int]?
  public var backDropPath: String?
  public var overview: String!
  public var originCountry: [String]!
  public var voteCount: Int!

  public var isActive: Bool = true  // MARK: - TODO, 🤦‍♂️ In what I was thinking?

  // MARK: - Remove
  public init(id: Int,
       name: String,
       voteAverage: Double,
       firstAirDate: String,
       posterPath: String,
       genreIds: [Int],
       backDropPath: String,
       overview: String,
       originCountry: [String],
       voteCount: Int) {
    self.id = id
    self.name = name
    self.voteAverage = voteAverage
    self.firstAirDate = firstAirDate
    self.posterPath = posterPath
    self.genreIds = genreIds
    self.backDropPath = backDropPath
    self.overview = overview
    self.originCountry = originCountry
    self.voteCount = voteCount
  }
}

extension TVShow {

  public var posterPathURL: URL? {
    guard let urlString = posterPath else { return nil}
    return URL(string: urlString)
  }

  public var backDropPathURL: URL? {
    guard let urlString = backDropPath else { return nil}
    return URL(string: urlString)
  }
}
