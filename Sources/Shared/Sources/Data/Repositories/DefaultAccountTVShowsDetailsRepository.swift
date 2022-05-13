//
//  DefaultAccountTVShowsDetailsRepository.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Combine
import NetworkingInterface

public final class DefaultAccountTVShowsDetailsRepository {
  private let showsRemoteDataSource: AccountTVShowsDetailsRemoteDataSourceProtocol
  private let mapper: AccountTVShowsDetailsMapperProtocol
  private let loggedUserRepository: LoggedUserRepositoryProtocol

  public init(showsRemoteDataSource: AccountTVShowsDetailsRemoteDataSourceProtocol,
              mapper: AccountTVShowsDetailsMapperProtocol,
              loggedUserRepository: LoggedUserRepositoryProtocol) {
    self.showsRemoteDataSource = showsRemoteDataSource
    self.mapper = mapper
    self.loggedUserRepository = loggedUserRepository
  }
}

extension DefaultAccountTVShowsDetailsRepository: AccountTVShowsDetailsRepository {

  // MARK: - TODO, handle nil cases, consider change the LoggedUserRepository signature instead

  public func markAsFavorite(tvShowId: Int, favorite: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError> {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0

    return showsRemoteDataSource.markAsFavorite(tvShowId: tvShowId, userId: String(userId), session: loggedUser?.sessionId ?? "", favorite: favorite)
      .map { self.mapper.mapActionResult(result: $0) }
      .eraseToAnyPublisher()
  }

  public func saveToWatchList(tvShowId: Int, watchedList: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError> {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0

    return showsRemoteDataSource.saveToWatchList(tvShowId: tvShowId, userId: String(userId), session: loggedUser?.sessionId ?? "", watchedList: watchedList)
      .map { self.mapper.mapActionResult(result: $0) }
      .eraseToAnyPublisher()
  }

  public func fetchTVShowStatus(tvShowId: Int) -> AnyPublisher<TVShowAccountStatus, DataTransferError> {
    let sessionId = loggedUserRepository.getUser()?.sessionId ?? ""
    return showsRemoteDataSource.fetchTVShowStatus(tvShowId: tvShowId, sessionId: sessionId)
      .map { self.mapper.mapTVShowStatusResult(result: $0) }
      .eraseToAnyPublisher()
  }
}
