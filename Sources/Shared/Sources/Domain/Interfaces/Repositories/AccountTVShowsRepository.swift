//
//  AccountTVShowsRepository.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsRepository {
  func fetchFavoritesShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchWatchListShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
}
