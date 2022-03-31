//
//  FetchTVShowDetailsUseCaseMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Combine
import NetworkingInterface
import Shared
@testable import ShowDetails

class FetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCase {
  var result: TVShowDetailResult?
  var error: DataTransferError?

  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetailResult, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
