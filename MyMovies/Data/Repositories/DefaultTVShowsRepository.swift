//
//  DefaultTVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultTVShowsRepository {
  
  private let dataTransferService: DataTransferService
  
  private let basePath: String?
  
  init(dataTransferService: DataTransferService,
       basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - TVShowsRepository

extension DefaultTVShowsRepository: TVShowsRepository {
  
  // MARK: - Support Generic Fetch TVShows
  
  func fetchTVShowsList(with filter: TVShowsListFilter, page: Int) -> Observable<TVShowResult> {
    let endPoint = getProvider(with: filter, page: page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }
  
  private func getProvider(with filter: TVShowsListFilter, page: Int) -> EndPoint {
    switch filter {
    case .today:
      return TVShowsProvider.getAiringTodayShows(page)
    case .popular:
      return TVShowsProvider.getPopularTVShows(page)
    case .byGenre(let genreId):
      return TVShowsProvider.listTVShowsBy(genreId, page)
    case .search(let query):
      return TVShowsProvider.searchTVShow(query, page)
    case .favorites(let userId, let sessionId):
      return AccountProvider.favorites(page: page, userId: String(userId), sessionId: sessionId)
    case .watchList(let userId, let sessionId):
      return AccountProvider.watchList(page: page, userId: String(userId), sessionId: sessionId)
    }
  }
  
  fileprivate func mapShowDetailsWithBasePath(response: TVShowResult) -> TVShowResult {
    guard let basePath = basePath else { return response }
    
    var newResponse = response
    
    newResponse.results = response.results.map { (show: TVShow) -> TVShow in
      var mutableShow = show
      mutableShow.backDropPath = basePath + "/t/p/w780" + ( show.backDropPath ?? "" )
      mutableShow.posterPath = basePath + "/t/p/w780" + ( show.posterPath ?? "" )
      return mutableShow
    }
    
    return newResponse
  }
  
  // MARK: - Fetch TVShow Account State
  
  func fetchTVAccountStates(tvShowId: Int, sessionId: String) -> Observable<TVShowAccountStateResult> {
    let endPoint = TVShowsProvider.getAccountStates(tvShowId: tvShowId,
                                                    sessionId: sessionId)
    return dataTransferService.request(endPoint, TVShowAccountStateResult.self)
  }
  
  // MARK: - Fetch TVShow Details
  
  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult> {
    
    let endPoint = TVShowsProvider.getTVShowDetail(showId)
    
    return dataTransferService.request(endPoint, TVShowDetailResult.self)
      .flatMap { response -> Observable<TVShowDetailResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response))
      }
  }
  
  fileprivate func mapShowDetailsWithBasePath(response: TVShowDetailResult) -> TVShowDetailResult {
    guard let basePath = basePath else { return response }
    
    var newResponse = response
    newResponse.backDropPath = basePath + "/t/p/w780" + ( response.backDropPath ?? "" )
    newResponse.posterPath = basePath + "/t/p/w780" + ( response.posterPath ?? "" )
    return newResponse
  }
}
