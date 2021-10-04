//
//  GenreListResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Shared

extension GenreListResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case genres
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.genres = try container.decode([Genre].self, forKey: .genres)
  }
}
