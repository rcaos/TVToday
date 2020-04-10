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
  
  func fetchTVShowsList(with filter: TVShowsListFilter, page: Int) -> Observable<TVShowResult> {
    let endPoint = getProvider(with: filter, page: page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }
  
  private func getProvider(with filter: TVShowsListFilter, page: Int) -> TVShowsProvider {
    switch filter {
    case .today:
      return TVShowsProvider.getAiringTodayShows(page)
    case .popular:
      return TVShowsProvider.getPopularTVShows(page)
    case .byGenre(let genreId):
      return TVShowsProvider.listTVShowsBy(genreId, page)
    case .search(let query):
      return TVShowsProvider.searchTVShow(query, page)
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
}
