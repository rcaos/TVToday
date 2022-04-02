//
//  SaveToWatchListUseCaseMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Combine
import NetworkingInterface
@testable import ShowDetails
@testable import Shared

class SaveToWatchListUseCaseMock: SaveToWatchListUseCase {
  var result: Bool?
  var error: DataTransferError?

  func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
