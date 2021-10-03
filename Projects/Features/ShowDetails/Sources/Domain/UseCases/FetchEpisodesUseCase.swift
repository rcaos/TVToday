//
//  FetchEpisodesUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchEpisodesUseCase {
  func execute(requestValue: FetchEpisodesUseCaseRequestValue) -> Observable<SeasonResult>
}

struct FetchEpisodesUseCaseRequestValue {
  let showIdentifier: Int
  let seasonNumber: Int
}

// MARK: - DefaultFetchEpisodesUseCase
final class DefaultFetchEpisodesUseCase: FetchEpisodesUseCase {

  private let episodesRepository: TVEpisodesRepository

  init(episodesRepository: TVEpisodesRepository) {
    self.episodesRepository = episodesRepository
  }

  func execute(requestValue: FetchEpisodesUseCaseRequestValue) -> Observable<SeasonResult> {
    return episodesRepository.fetchEpisodesList(
      for: requestValue.showIdentifier,
      season: requestValue.seasonNumber)
  }
}
