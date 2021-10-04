//
//  DefaultFetchAiringTodayTVShowsUseCase.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import RxSwift
import Shared

final class DefaultFetchAiringTodayTVShowsUseCase: FetchTVShowsUseCase {
  private let tvShowsRepository: TVShowsRepository

  init(tvShowsRepository: TVShowsRepository) {
    self.tvShowsRepository = tvShowsRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    return tvShowsRepository.fetchAiringTodayShows(page: requestValue.page)
  }
}
