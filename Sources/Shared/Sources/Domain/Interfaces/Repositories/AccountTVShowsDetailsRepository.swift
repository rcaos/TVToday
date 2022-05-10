//
//  AccountTVShowsDetailsRepository.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsDetailsRepository {
  func markAsFavorite(tvShowId: Int, favorite: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError>

  func saveToWatchList(tvShowId: Int, watchedList: Bool) -> AnyPublisher<TVShowActionStatus, DataTransferError>

  func fetchTVShowStatus(tvShowId: Int) -> AnyPublisher<TVShowAccountStatus, DataTransferError>
}
