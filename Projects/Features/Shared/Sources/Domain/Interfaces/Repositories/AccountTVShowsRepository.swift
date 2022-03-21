//
//  AccountTVShowsRepository.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import NetworkingInterface
import RxSwift

public protocol AccountTVShowsRepository {
  func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> Observable<TVShowResult>

  func fetchTVAccountStates(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStateResult, DataTransferError>

  func markAsFavorite(session: String, userId: String, tvShowId: Int, favorite: Bool) -> Observable<StatusResult>

  func saveToWatchList(session: String, userId: String, tvShowId: Int, watchedList: Bool) -> Observable<StatusResult>
}
