//
//  TVShowResult.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct TVShowResult {
  
  let page: Int!
  var results: [TVShow]!
  let totalResults: Int!
  let totalPages: Int!
}

extension TVShowResult {
  
  var hasMorePages: Bool {
    return totalPages > page
  }
  
  var nextPage: Int {
    return page + 1
  }
}
