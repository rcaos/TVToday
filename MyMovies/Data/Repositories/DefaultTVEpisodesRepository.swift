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
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - TVEpisodesRepository

extension DefaultTVEpisodesRepository: TVEpisodesRepository {
  
  func fetchEpisodesList(for show: Int, season: Int) -> Observable<SeasonResult> {
    let endPoint = TVShowsProvider.getEpisodesFor(show, season)
    return dataTransferService.request(endPoint, SeasonResult.self)
  }
}
