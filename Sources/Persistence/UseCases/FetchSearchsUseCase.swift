//
//  FetchSearchesUseCase.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/7/20.
//

import Combine
import Shared

public protocol FetchSearchesUseCase {
  func execute(requestValue: FetchSearchesUseCaseRequestValue) -> AnyPublisher<[Search], ErrorEnvelope>
}

public struct FetchSearchesUseCaseRequestValue {
  public init() { }
}

public final class DefaultFetchSearchesUseCase: FetchSearchesUseCase {
  private let searchLocalRepository: SearchLocalRepositoryProtocol

  public init(searchLocalRepository: SearchLocalRepositoryProtocol) {
    self.searchLocalRepository = searchLocalRepository
  }

  public func execute(requestValue: FetchSearchesUseCaseRequestValue) -> AnyPublisher<[Search], ErrorEnvelope> {
    return searchLocalRepository.fetchRecentSearches()
  }
}
