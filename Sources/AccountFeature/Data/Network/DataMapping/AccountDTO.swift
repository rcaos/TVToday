//
//  AccountDTO.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct AccountDTO: Decodable {
  let id: Int
  let userName: String
  let avatar: AvatarDTO?

  enum CodingKeys: String, CodingKey {
    case avatar
    case id
    case userName = "username"
  }
}

// MARK: - Avatar
public struct AvatarDTO: Decodable {
  let gravatar: GravatarDTO?

  enum CodingKeys: String, CodingKey {
    case gravatar
  }
}

// MARK: - Gravatar
public struct GravatarDTO: Decodable {
  let hash: String?

  enum CodingKeys: String, CodingKey {
    case hash
  }
}
