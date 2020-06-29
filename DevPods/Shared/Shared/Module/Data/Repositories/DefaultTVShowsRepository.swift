//
//  DefaultTVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Networking

public final class DefaultTVShowsRepository {
  
  private let dataTransferService: DataTransferService
  
  private let basePath: String?
  
  public init(dataTransferService: DataTransferService, basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - TVShowsRepository

extension DefaultTVShowsRepository: TVShowsRepository {
  
  public func fetchAiringTodayShows(page: Int) -> Observable<TVShowResult> {
    let endPoint = TVShowsProvider.getAiringTodayShows(page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }
  
  public func fetchPopularShows(page: Int) -> Observable<TVShowResult> {
    let endPoint = TVShowsProvider.getPopularTVShows(page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }
  
  public func fetchShowsByGenre(genreId: Int, page: Int) -> Observable<TVShowResult> {
    let endPoint = TVShowsProvider.listTVShowsBy(genreId, page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }
  
  public func searchShowsFor(query: String, page: Int) -> Observable<TVShowResult> {
    let endPoint = TVShowsProvider.searchTVShow(query, page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
      .flatMap { response -> Observable<TVShowResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response) )
    }
  }
  
  // MARK: - Map responses with ImageBase URL
  
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
  
  // MARK: - Fetch TVShow Details
  
  public func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult> {
    
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
