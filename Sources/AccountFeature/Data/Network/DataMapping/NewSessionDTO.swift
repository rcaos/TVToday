//
//  NewSessionDTO.swift
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct NewSessionDTO: Decodable {
  let success: Bool
  let sessionId: String

  enum CodingKeys: String, CodingKey {
    case success
    case sessionId = "session_id"
  }
}
