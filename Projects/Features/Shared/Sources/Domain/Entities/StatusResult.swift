//
//  StatusResult.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct StatusResult: Decodable {
  let statusCode: Int?
  let statusMessage: String?
  
  enum CodingKeys: String, CodingKey {
    case statusCode = "status_code"
    case statusMessage = "status_message"
  }
}
