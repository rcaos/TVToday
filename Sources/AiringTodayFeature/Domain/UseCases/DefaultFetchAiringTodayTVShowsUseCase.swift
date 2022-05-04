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
  private let tvShowsRepository: TVShowsRepository
  private let tvShowsPageRepository: TVShowsPageRepository

  init(tvShowsRepository: TVShowsRepository, tvShowsPageRepository: TVShowsPageRepository) {
    self.tvShowsRepository = tvShowsRepository
    self.tvShowsPageRepository = tvShowsPageRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    return tvShowsRepository.fetchAiringTodayShows(page: requestValue.page)
  }

  func execute2(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return tvShowsPageRepository.fetchAiringTodayShows(page: requestValue.page)
  }
}
