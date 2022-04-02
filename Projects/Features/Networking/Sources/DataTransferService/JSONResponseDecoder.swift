//
//  JSONResponseDecoder.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import NetworkingInterface

public class JSONResponseDecoder: ResponseDecoder {
  private let jsonDecoder = JSONDecoder()

  public init() { }

  public func decode<T: Decodable>(_ data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}
