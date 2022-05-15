//
//  AccountTVShowsDetailsRemoteDataSourceProtocol.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsDetailsRemoteDataSourceProtocol {
  func markAsFavorite(tvShowId: Int, userId: String,session: String,  favorite: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError>

  func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError>

  func fetchTVShowStatus(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStatusDTO, DataTransferError>
}
