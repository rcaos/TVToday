//
//  DefaultAccountTVShowsRepository.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import NetworkingInterface
import Networking

public final class DefaultAccountTVShowsRepository {
  private let showsPageRemoteDataSource: TVShowsRemoteDataSource
  private let mapper: TVShowPageMapper
  private let imageBasePath: String

  public init(showsPageRemoteDataSource: TVShowsRemoteDataSource, mapper: TVShowPageMapper, imageBasePath: String) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
  }
}

extension DefaultAccountTVShowsRepository: AccountTVShowsRepository {

  public func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPage, DataTransferError> {
    return showsPageRemoteDataSource.fetchFavoritesShows(page: page, userId: userId, sessionId: sessionId)
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }

  public func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPage, DataTransferError> {
    return showsPageRemoteDataSource.fetchWatchListShows(page: page, userId: userId, sessionId: sessionId)
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }
}
