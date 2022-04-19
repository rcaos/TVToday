//
//  FetchSearchsUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
@testable import SearchShows
@testable import Shared
@testable import Persistence

final class FetchSearchsUseCaseMock: FetchSearchsUseCase {
  var error: CustomError?
  var result: [Search]?

  public func execute(requestValue: FetchSearchsUseCaseRequestValue) -> AnyPublisher<[Search], CustomError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: CustomError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: CustomError.self).eraseToAnyPublisher()
  }
}
