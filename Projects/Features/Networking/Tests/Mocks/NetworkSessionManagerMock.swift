//
//  NetworkSessionManagerMock.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import Combine
@testable import NetworkingInterface

struct NetworkSessionManagerMock: NetworkSessionManager {
  let response: HTTPURLResponse?
  let data: Data?
  let error: URLError?

  func request(_ request: URLRequest) -> AnyPublisher<NetworkingOutput, URLError> {
    if let customError = error {
      return Fail(error: customError)
        .eraseToAnyPublisher()

    } else if let data = data, let response = response {
      return Just((data: data, response: response))
        .setFailureType(to: URLError.self)
        .eraseToAnyPublisher()
    }
    return Empty(outputType: NetworkingOutput.self, failureType: URLError.self)
      .eraseToAnyPublisher()
  }
}
