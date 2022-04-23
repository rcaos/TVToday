//
//  CreateSessionResult+Decodable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension CreateSessionResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case success
    case sessionId = "session_id"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId)
  }
}
