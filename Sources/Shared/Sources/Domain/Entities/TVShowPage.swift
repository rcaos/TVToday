//
//  TVShowPage.swift
//  
//
//  Created by Jeans Ruiz on 30/04/22.
//

import Foundation

public struct TVShowPage {
  public let page: Int
  public let showsList: [TVShow]
  public let totalPages: Int
  public let totalShows: Int

  // https://api.themoviedb.org/3/tv/airing_today?page=1&language=es-US&api_key=06e1a8c1f39b7a033e2efb972625fee2
  public struct TVShow: Hashable {
    public let id: Int  // 52698
    public let name: String // "El Kabeer"
    public let overview: String // "lorep ipsum ...."

    public let firstAirDate: String // "2010-08-11"

    // "https://image.tmdb.org/t/p/w780/Ap86RyRhP7ikeRCpysnfC9PO2H0.jpg"  1. Cambia baseURL and Size
    public let posterPath: URL? //    "/Ap86RyRhP7ikeRCpysnfC9PO2H0.jpg"

    // "https://image.tmdb.org/t/p/w780/5dJccl3yF1Er6HVZDceYZC3rzhh.jpg"
    public let backDropPath: URL? //  "/5dJccl3yF1Er6HVZDceYZC3rzhh.jpg"

    public let genreIds: [Int]  // [35]
    public let voteAverage: Double // 7.3
    public let voteCount: Int // 14s
  }

  public init(page: Int, showsList: [TVShow], totalPages: Int, totalShows: Int) {
    self.page = page
    self.showsList = showsList
    self.totalPages = totalPages
    self.totalShows = totalShows
  }
}

extension TVShowPage {

  public var hasMorePages: Bool {
    return totalPages > page
  }

  public var nextPage: Int {
    return page + 1
  }
}
