//
//  AccountTVShowsRepository.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsRepository {
  func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPage, DataTransferError>
}

public protocol AccountTVShowsDetailsRepository {
  func markAsFavorite(tvShowId: Int, userId: String,session: String,  favorite: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError>
  func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError>
  func fetchTVShowStatus(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStatus, DataTransferError>
}
