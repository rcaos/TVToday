//
//  Account+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension AccountResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case avatar
    case id
    case userName = "username"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.avatar = try container.decodeIfPresent(Avatar.self, forKey: .avatar)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
  }
}

// MARK: - Avatar
extension Avatar: Decodable {
  enum CodingKeys: String, CodingKey {
    case gravatar
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.gravatar = try container.decodeIfPresent(Gravatar.self, forKey: .gravatar)
  }
}

// MARK: - Gravatar
extension Gravatar: Decodable {
  enum CodingKeys: String, CodingKey {
     case hash
   }

   public init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: CodingKeys.self)

     self.hash = try container.decodeIfPresent(String.self, forKey: .hash)
   }
}
