//
//  CreateTokenResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension CreateTokenResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case success
    case expiresAt = "expires_at"
    case token = "request_token"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.expiresAt = try container.decodeIfPresent(String.self, forKey: .expiresAt)
    self.token = try container.decode(String.self, forKey: .token)
  }
}
