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
  var headerParamaters: [String: String] { get }
  var queryParametersEncodable: Encodable? { get }
  var queryParameters: [String: Any] { get }
  var bodyParamatersEncodable: Encodable? { get }
  var bodyParamaters: [String: Any] { get }
  var bodyEncoding: BodyEncoding { get }

  func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

public enum HTTPMethodType: String {
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
}

public enum BodyEncoding {
  case jsonSerializationData
  case stringEncodingAscii
}

public protocol ResponseRequestable: Requestable {
  associatedtype Response

  var responseDecoder: ResponseDecoder { get }
}

public enum RequestGenerationError: Error {
  case components
}
