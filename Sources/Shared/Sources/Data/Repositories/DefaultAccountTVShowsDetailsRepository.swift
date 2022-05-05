//
//  DefaultAccountTVShowsDetailsRepository.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Combine
import NetworkingInterface

public final class DefaultAccountTVShowsDetailsRepository {
  private let showsPageRemoteDataSource: TVShowsRemoteDataSource
  private let mapper: AccountTVShowsDetailsMapperProtocol

  public init(showsPageRemoteDataSource: TVShowsRemoteDataSource, mapper: AccountTVShowsDetailsMapperProtocol) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
  }
}

extension DefaultAccountTVShowsDetailsRepository: AccountTVShowsDetailsRepository {

  public func markAsFavorite(tvShowId: Int, userId: String, session: String, favorite: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError> {
    return showsPageRemoteDataSource.markAsFavorite(tvShowId: tvShowId, userId: userId, session: session, favorite: favorite)
      .map { self.mapper.mapActionResult(result: $0) }
      .eraseToAnyPublisher()
  }

  public func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError> {
    return showsPageRemoteDataSource.saveToWatchList(tvShowId: tvShowId, userId: userId, session: session, watchedList: watchedList)
      .map { self.mapper.mapActionResult(result: $0) }
      .eraseToAnyPublisher()
  }

  public func fetchTVShowStatus(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStatus, DataTransferError> {
    return showsPageRemoteDataSource.fetchTVShowStatus(tvShowId: tvShowId, sessionId: sessionId)
      .map { self.mapper.mapTVShowStatusResult(result: $0) }
      .eraseToAnyPublisher()
  }
}
