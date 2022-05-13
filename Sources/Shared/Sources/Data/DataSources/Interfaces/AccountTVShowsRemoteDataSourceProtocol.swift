//
//  AccountTVShowsRemoteDataSourceProtocol.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsRemoteDataSourceProtocol {
  func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError>
}
