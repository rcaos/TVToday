//
//  TVShowActionStatusDTO.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Foundation

public struct TVShowActionStatusDTO: Decodable {
  let code: Int
  let message: String?

  enum CodingKeys: String, CodingKey {
    case code = "status_code"
    case message = "status_message"
  }
}
