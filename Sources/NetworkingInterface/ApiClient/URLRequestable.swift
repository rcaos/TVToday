//
//  Created by Jeans Ruiz on 11/08/23.
//

import Foundation

public protocol URLRequestable {
  func urlRequest(with: NetworkConfig) throws -> URLRequest
  var responseDecoder: ResponseDecoder { get }
}

public protocol ResponseDecoder {
  func decode<A: Decodable>(_ type: A.Type, from data: Data) throws -> A
}
