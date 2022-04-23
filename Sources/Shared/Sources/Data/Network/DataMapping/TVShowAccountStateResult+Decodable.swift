//
//  TVShowAccountStateResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension TVShowAccountStateResult: Decodable {

  enum CodingKeys: String, CodingKey {
    case id
    case isFavorite = "favorite"
    case isWatchList = "watchlist"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(Int.self, forKey: .id)
    self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    self.isWatchList = try container.decode(Bool.self, forKey: .isWatchList)
  }
}
