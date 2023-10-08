//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation

public struct JSONResponseDecoder: ResponseDecoder {
  private let jsonDecoder = JSONDecoder()

  public init() {}

  public func decode<A>(_ type: A.Type, from data: Data) throws -> A where A : Decodable {
    return try jsonDecoder.decode(A.self, from: data)
  }
}
