//
//  DataTransferService2.swift  //TODO change
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import Combine
import RxSwift  // MARK: - Remove Soon

public protocol DataTransferService {
  func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> AnyPublisher<T, DataTransferError> where E.Response == T

  func request<E: ResponseRequestable>(with endpoint: E) -> AnyPublisher<Data, DataTransferError> where E.Response == Data

  // MARK: - Remove soon
  func request<Element: Decodable>(_ router: EndPoint, _ type: Element.Type) -> Observable<Element>
}

// MARK: - Remove soon
public protocol EndPoint {
  var path: String { get }
  var method: ServiceMethod { get }
  var queryParameters: [String: Any]? { get }
  var parameterEncoding: ParameterEnconding { get }
}

public enum ServiceMethod: String {
  case get = "GET"
  case post = "POST"
}

public enum ParameterEnconding {
  case defaultEncoding
  case jsonEncoding
  case compositeEncoding
}
//

public enum DataTransferError: Error {
  case noResponse
  case parsing(Error)
  case networkFailure(NetworkError)
  case resolvedNetworkFailure(Error)
}

public protocol DataTransferErrorResolver {
  func resolve(error: NetworkError) -> Error
}

public protocol ResponseDecoder {
  func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol DataTransferErrorLogger {
  func log(error: Error)
}
