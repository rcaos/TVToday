//
//  SearchTVShowsUseCase.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Shared
import Persistence
import NetworkingInterface
import Foundation

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
  private let searchsLocalRepository: SearchLocalRepository

  public init(tvShowsPageRepository: TVShowsPageRepository,
              searchsLocalRepository: SearchLocalRepository) {
    self.tvShowsPageRepository = tvShowsPageRepository
    self.searchsLocalRepository = searchsLocalRepository
  }

  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return tvShowsPageRepository.searchShowsFor(query: requestValue.query, page: requestValue.page)
      .receive(on: DispatchQueue.main)  // MARK: - TODO, Change
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
