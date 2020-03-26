//
//  TVShow.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct TVShow {
  
  var id: Int!
  var name: String!
  var voteAverage: Double!
  var firstAirDate: String?
  
  var posterPath: String?
  var genreIds: [Int]?
  var backDropPath: String?
  var overview: String!
  var originCountry: [String]!
  var voteCount: Int!
}

extension TVShow {
  
  // MARK: - TODO inject Base
  public func getposterPathURL(base: String = "https://image.tmdb.org/t/p/w780") -> URL? {
    guard let urlString = posterPath else { return nil }
    return URL(string: "\(base)\(urlString)")
  }
  
  public func getbackDropPathURL(base: String = "https://image.tmdb.org/t/p/w780") -> URL? {
    guard let backDropString = backDropPath else { return nil }
    return URL(string: "\(base)\(backDropString)")
  }
}
