//
//  FetchTVAccountStateMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Combine
import NetworkingInterface
import Shared
@testable import ShowDetailsFeature

class FetchTVAccountStateMock: FetchTVAccountStates {

  var result: TVShowAccountStateResult?
  var error: DataTransferError?

  func execute(requestValue: FetchTVAccountStatesRequestValue) -> AnyPublisher<TVShowAccountStateResult, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
