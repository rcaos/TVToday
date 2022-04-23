//
//  FetchGenresUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import NetworkingInterface
@testable import SearchShowsFeature

final class FetchGenresUseCaseMock: FetchGenresUseCase {
  var error: DataTransferError?
  var result: GenreListResult?

  func execute(requestValue: FetchGenresUseCaseRequestValue) -> AnyPublisher<GenreListResult, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
