//
//  CreateSessionUseCaseMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
import NetworkingInterface
@testable import Account

final class CreateSessionUseCaseMock: CreateSessionUseCase {

  var result: Void?
  var error: DataTransferError?

  func execute() -> AnyPublisher<Void, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self) .eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
