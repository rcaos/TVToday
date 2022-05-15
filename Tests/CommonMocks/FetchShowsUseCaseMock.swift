//
//  FetchShowsUseCaseMock.swift
//  
//
//  Created by Jeans Ruiz on 14/05/22.
//

import Foundation
import Combine
import NetworkingInterface
@testable import Shared

public class FetchShowsUseCaseMock: FetchTVShowsUseCase {

  public var error: DataTransferError?
  public var result: TVShowPage?

  public init() { }

  public func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }
}
