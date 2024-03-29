//
//  FetchGenresUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import CommonMocks
import Combine
import SearchShowsFeature
import Shared
import NetworkingInterface

final class SearchTVShowsUseCaseMock: SearchTVShowsUseCase {
  var error: DataTransferError?
  var result: TVShowPage?

  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
