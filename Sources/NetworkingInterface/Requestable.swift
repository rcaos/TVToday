//
//  Requestable.swift
//  NetworkingInterface
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation

public protocol Requestable {
  var path: String { get }
  var isFullPath: Bool { get }
  var method: HTTPMethodType { get }
  var headerParameters: [String: String] { get }
  var queryParametersEncodable: Encodable? { get }
  var queryParameters: [String: Any] { get }
  var bodyParametersEncodable: Encodable? { get }
  var bodyParameters: [String: Any] { get }
  var bodyEncoding: BodyEncoding { get }

  func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

public protocol ResponseRequestable: Requestable {
  associatedtype Response

  var responseDecoder: ResponseDecoder_Old { get }
}
