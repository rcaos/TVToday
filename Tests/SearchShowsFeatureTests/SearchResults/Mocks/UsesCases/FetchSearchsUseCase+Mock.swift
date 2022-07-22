//
//  FetchSearchsUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
@testable import SearchShowsFeature
@testable import Shared
@testable import Persistence

final class FetchSearchsUseCaseMock: FetchSearchesUseCase {
  var error: ErrorEnvelope?
  var result: [Search]?

  public func execute(requestValue: FetchSearchesUseCaseRequestValue) -> AnyPublisher<[Search], ErrorEnvelope> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
  }
}
