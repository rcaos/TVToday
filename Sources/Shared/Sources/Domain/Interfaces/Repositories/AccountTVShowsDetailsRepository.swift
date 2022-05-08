//
//  AccountTVShowsDetailsRepository.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsDetailsRepository {
  func markAsFavorite(tvShowId: Int,
                      userId: String,
                      session: String,
                      favorite: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError>

  func saveToWatchList(tvShowId: Int,
                       userId: String,
                       session: String,
                       watchedList: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError>

  func fetchTVShowStatus(tvShowId: Int,
                         sessionId: String) -> AnyPublisher<TVShowAccountStatus, DataTransferError>
}
