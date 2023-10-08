//
//  RawDataResponseDecoder.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import NetworkingInterface

public class RawDataResponseDecoder: ResponseDecoder_Old {

  public init() { }

  enum CodingKeys: String, CodingKey {
    case `default` = ""
  }

  public func decode<T: Decodable>(_ data: Data) throws -> T {
    if T.self is Data.Type, let data = data as? T {
      return data
    } else {
      let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
      throw Swift.DecodingError.typeMismatch(T.self, context)
    }
  }
}
