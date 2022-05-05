//
//  GenreDTO.swift
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension Genre: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
  }
}

public struct GenreDTO: Decodable {
  public var id: Int
  public var name: String

  enum CodingKeys: String, CodingKey {
    case id
    case name
  }
}

