//
//  FetchSearchesUseCase.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/7/20.
//

import Combine
import Shared

public protocol FetchSearchesUseCase {
  func execute(requestValue: FetchSearchesUseCaseRequestValue) -> AnyPublisher<[Search], CustomError>
}

public struct FetchSearchesUseCaseRequestValue {
  public init() { }
}

public final class DefaultFetchSearchesUseCase: FetchSearchesUseCase {
  private let searchLocalRepository: SearchLocalRepository

  public init(searchLocalRepository: SearchLocalRepository) {
    self.searchLocalRepository = searchLocalRepository
  }

  public func execute(requestValue: FetchSearchesUseCaseRequestValue) -> AnyPublisher<[Search], CustomError> {
    return searchLocalRepository.fetchRecentSearches()
  }
}
