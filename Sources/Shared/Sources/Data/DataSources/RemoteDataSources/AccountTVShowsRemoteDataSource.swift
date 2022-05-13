//
//  AccountTVShowsRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import Networking
import NetworkingInterface

public class AccountTVShowsRemoteDataSource {
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension AccountTVShowsRemoteDataSource: AccountTVShowsRemoteDataSourceProtocol {
  public func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/account/\(userId)/favorite/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/account/\(userId)/watchlist/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }
}
