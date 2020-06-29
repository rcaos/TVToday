//
//  TVShow.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct TVShow {
  
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
