//
//  SearchTVShowsUseCase.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Foundation
import NetworkingInterface
import Persistence
import Shared
import UI

public protocol SearchTVShowsUseCase {
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError>
}

public struct SearchTVShowsUseCaseRequestValue {
  public let query: String
  public let page: Int
}

// MARK: - SearchTVShowsUseCase
final class DefaultSearchTVShowsUseCase: SearchTVShowsUseCase {
  private let tvShowsPageRepository: TVShowsPageRepository
  private let searchsLocalRepository: SearchLocalRepositoryProtocol

  public init(tvShowsPageRepository: TVShowsPageRepository,
              searchsLocalRepository: SearchLocalRepositoryProtocol) {
    self.tvShowsPageRepository = tvShowsPageRepository
    self.searchsLocalRepository = searchsLocalRepository
  }

  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return tvShowsPageRepository.searchShowsFor(query: requestValue.query, page: requestValue.page)
      .receive(on: defaultScheduler)
      .flatMap { resultSearch -> AnyPublisher<TVShowPage, DataTransferError> in
        if requestValue.page == 1 {
          return self.searchsLocalRepository.saveSearch(query: requestValue.query)
            .map { _ in resultSearch }
            .mapError { _ -> DataTransferError in DataTransferError.noResponse }
            .eraseToAnyPublisher()
        } else {
          return Just(resultSearch).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
}
