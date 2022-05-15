//
//  NewRequestTokenDTO.swift
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct NewRequestTokenDTO: Decodable {
  let success: Bool
  let token: String

  enum CodingKeys: String, CodingKey {
    case success
    case token = "request_token"
  }
}
