//
//  FetchShowsUseCaseMock.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Combine
import NetworkingInterface
@testable import Shared

class FetchShowsUseCaseMock: FetchTVShowsUseCase {

  var error: DataTransferError?
  var result: TVShowResult?

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
