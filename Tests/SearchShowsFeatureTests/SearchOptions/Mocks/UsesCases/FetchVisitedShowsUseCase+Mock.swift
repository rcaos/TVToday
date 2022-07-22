//
//  FetchVisitedShowsUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import Persistence
import Shared

final class FetchVisitedShowsUseCaseMock: FetchVisitedShowsUseCase {
  var error: ErrorEnvelope?
  var result: [ShowVisited]?

  func execute(requestValue: FetchVisitedShowsUseCaseRequestValue) -> AnyPublisher<[ShowVisited], ErrorEnvelope> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
  }
}
