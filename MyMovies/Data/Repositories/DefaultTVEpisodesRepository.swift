//
//  DefaultTVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultTVEpisodesRepository {
  
  private let dataTransferService: DataTransferService
  
  private let basePath: String?
  
  init(dataTransferService: DataTransferService,
       basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - TVEpisodesRepository

extension DefaultTVEpisodesRepository: TVEpisodesRepository {
  
  func fetchEpisodesList(for show: Int, season: Int) -> Observable<SeasonResult> {
    let endPoint = TVShowsProvider.getEpisodesFor(show, season)
    return dataTransferService.request(endPoint, SeasonResult.self)
      .flatMap { response -> Observable<SeasonResult> in
          Observable.just( self.mapEpisodesWithBasePath(response: response) )
      }
  }
  
  fileprivate func mapEpisodesWithBasePath(response: SeasonResult) -> SeasonResult {
    guard let basePath = basePath else { return response }
    
    var newResponse = response

    newResponse.episodes  = response.episodes?.map { (episode: Episode) -> Episode in
      var mutableEpisode = episode
      mutableEpisode.posterPath = basePath + "/t/p/w342" + ( episode.posterPath ?? "" )
      return mutableEpisode
    }
    
    return newResponse
  }
}
