//
//  DefaultFetchAiringTodayTVShowsUseCase.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Shared
import NetworkingInterface

final class DefaultFetchAiringTodayTVShowsUseCase: FetchTVShowsUseCase {
  private let tvShowsPageRepository: TVShowsPageRepository

  init(tvShowsPageRepository: TVShowsPageRepository) {
    self.tvShowsPageRepository = tvShowsPageRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return tvShowsPageRepository.fetchAiringTodayShows(page: requestValue.page)
  }
}
