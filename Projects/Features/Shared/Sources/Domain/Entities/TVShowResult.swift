//
//  TVShowResult.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

// MARK: - TODO, avoid force unwrapping!
public struct TVShowResult {
  public let page: Int!
  public var results: [TVShow]!
  public let totalResults: Int!
  public let totalPages: Int!
}

extension TVShowResult {

  public var hasMorePages: Bool {
    return totalPages > page
  }

  public var nextPage: Int {
    return page + 1
  }
}
