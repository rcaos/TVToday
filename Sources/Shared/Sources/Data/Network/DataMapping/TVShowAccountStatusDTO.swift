//
//  TVShowAccountStatusDTO.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Foundation

public struct TVShowAccountStatusDTO: Decodable {
  public let showId: Int
  public let isFavorite: Bool
  public let isWatchList: Bool

  enum CodingKeys: String, CodingKey {
    case showId = "id"
    case isFavorite = "favorite"
    case isWatchList = "watchlist"
  }
}
