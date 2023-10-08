//
//  AccountTVShowsDetailsRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import Networking
import NetworkingInterface

public class AccountTVShowsDetailsRemoteDataSource {
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension AccountTVShowsDetailsRemoteDataSource: AccountTVShowsDetailsRemoteDataSourceProtocol {
  public func markAsFavorite(tvShowId: Int, userId: String, session: String, favorite: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError> {
    let endpoint = Networking.Endpoint<TVShowActionStatusDTO>(
      path: "3/account/\(userId)/favorite",
      method: .post,
      queryParameters: [
        "session_id": session
      ],
      bodyParameters: [
        "media_type": "tv",
        "media_id": tvShowId,
        "favorite": favorite
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError> {
    let endpoint = Networking.Endpoint<TVShowActionStatusDTO>(
      path: "3/account/\(userId)/watchlist",
      method: .post,
      queryParameters: [
        "session_id": session
      ],
      bodyParameters: [
        "media_type": "tv",
        "media_id": tvShowId,
        "watchlist": watchedList
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchTVShowStatus(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStatusDTO, DataTransferError> {
    let endpoint = Networking.Endpoint<TVShowAccountStatusDTO>(
      path: "3/tv/\(String(tvShowId))/account_states",
      method: .get,
      queryParameters: [
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }
}
