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
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError>
}

public struct SearchTVShowsUseCaseRequestValue {
  public let query: String
  public let page: Int
}

// MARK: - SearchTVShowsUseCase
final class DefaultSearchTVShowsUseCase: SearchTVShowsUseCase {

  private let tvShowsRepository: TVShowsRepository
  private let searchsLocalRepository: SearchLocalRepository
  private let keychainRepository: KeychainRepository

  public init(tvShowsRepository: TVShowsRepository,
              keychainRepository: KeychainRepository,
              searchsLocalRepository: SearchLocalRepository) {
    self.tvShowsRepository = tvShowsRepository
    self.keychainRepository = keychainRepository
    self.searchsLocalRepository = searchsLocalRepository
  }

  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    var idLogged = 0
    if let userLogged = keychainRepository.fetchLoguedUser() {
      idLogged = userLogged.id
    }
    
    return tvShowsRepository.searchShowsFor(query: requestValue.query, page: requestValue.page)
      .receive(on: RunLoop.main)
      .flatMap { resultSearch -> AnyPublisher<TVShowResult, DataTransferError> in
        if requestValue.page == 1 {
          return self.searchsLocalRepository.saveSearch(query: requestValue.query, userId: idLogged)
            .map { _ in resultSearch }
            .mapError { _ -> DataTransferError in DataTransferError.noResponse  }
            .eraseToAnyPublisher()
        } else {
          return Just(resultSearch).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
}
