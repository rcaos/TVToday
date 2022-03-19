//
//  DataTransferService2.swift  //TODO change
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import Combine

public protocol DataTransferService2 {
  func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) -> AnyPublisher<T, DataTransferError> where E.Response == T

  func request<E: ResponseRequestable>(with endpoint: E) -> AnyPublisher<Data, DataTransferError> where E.Response == Data
}

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
