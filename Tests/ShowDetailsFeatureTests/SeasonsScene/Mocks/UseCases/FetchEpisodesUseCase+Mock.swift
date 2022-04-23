//
//  FetchEpisodesUseCase+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import Combine
import NetworkingInterface
@testable import ShowDetailsFeature

final class FetchEpisodesUseCaseMock: FetchEpisodesUseCase {
  var result: SeasonResult?
  var error: DataTransferError?

  func execute(requestValue: FetchEpisodesUseCaseRequestValue) -> AnyPublisher<SeasonResult, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
