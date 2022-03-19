//
//  DefaultAccountTVShowsRepository.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import RxSwift
import NetworkingInterface

public final class DefaultAccountTVShowsRepository {

  private let dataTransferService: DataTransferService

  private let basePath: String?

  public init(dataTransferService: DataTransferService,
              basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - AccountTVShowsRepository

extension DefaultAccountTVShowsRepository: AccountTVShowsRepository {

  public func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> Observable<TVShowResult> {
    let endPoint = AccountShowsProvider.favorites(page: page, userId: String(userId), sessionId: sessionId)

    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }

  public func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> Observable<TVShowResult> {
    let endPoint = AccountShowsProvider.watchList(page: page, userId: String(userId), sessionId: sessionId)

    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }

  fileprivate func mapShowDetailsWithBasePath(response: TVShowResult) -> TVShowResult {
    guard let basePath = basePath else {
      return response
    }

    var newResponse = response

    newResponse.results = response.results.map { (show: TVShow) -> TVShow in
      var mutableShow = show
      mutableShow.backDropPath = basePath + "/t/p/w780" + ( show.backDropPath ?? "" )
      mutableShow.posterPath = basePath + "/t/p/w780" + ( show.posterPath ?? "" )
      return mutableShow
    }

    return newResponse
  }

  public func fetchTVAccountStates(tvShowId: Int, sessionId: String) -> Observable<TVShowAccountStateResult> {
    let endPoint = AccountShowsProvider.getAccountStates(tvShowId: tvShowId,
                                                    sessionId: sessionId)
    return dataTransferService.request(endPoint, TVShowAccountStateResult.self)
  }

  public func markAsFavorite(session: String, userId: String, tvShowId: Int, favorite: Bool) -> Observable<StatusResult> {
    let endPoint = AccountShowsProvider.markAsFavorite(
      userId: userId,
      tvShowId: tvShowId,
      sessionId: session,
      favorite: favorite)
    return dataTransferService.request(endPoint, StatusResult.self)
  }

  public func saveToWatchList(session: String, userId: String, tvShowId: Int, watchedList: Bool) -> Observable<StatusResult> {
    let endPoint = AccountShowsProvider.savetoWatchList(
      userId: userId,
      tvShowId: tvShowId,
      sessionId: session,
      watchList: watchedList)
    return dataTransferService.request(endPoint, StatusResult.self)
  }
}
