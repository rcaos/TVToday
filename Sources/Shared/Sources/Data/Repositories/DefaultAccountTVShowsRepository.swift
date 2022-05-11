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
  private let loggedUserRepository: LoggedUserRepositoryProtocol

  public init(showsPageRemoteDataSource: TVShowsRemoteDataSource, mapper: TVShowPageMapper, imageBasePath: String, loggedUserRepository: LoggedUserRepositoryProtocol) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
    self.loggedUserRepository = loggedUserRepository
  }
}

extension DefaultAccountTVShowsRepository: AccountTVShowsRepository {

  public func fetchFavoritesShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError> {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0

    return showsPageRemoteDataSource.fetchFavoritesShows(page: page, userId: userId, sessionId: loggedUser?.sessionId ?? "")
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }

  public func fetchWatchListShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError> {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0

    return showsPageRemoteDataSource.fetchWatchListShows(page: page, userId: userId, sessionId: loggedUser?.sessionId ?? "")
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }
}
