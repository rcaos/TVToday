//
//  DefaultFetchPopularTVShowsUseCase.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Shared
import NetworkingInterface

final class DefaultFetchPopularTVShowsUseCase: FetchTVShowsUseCase {
  private let tvShowsPageRepository: TVShowsPageRepository
  private let tvShowsRepository: TVShowsRepository

  init(tvShowsPageRepository: TVShowsPageRepository, tvShowsRepository: TVShowsRepository) {
    self.tvShowsPageRepository = tvShowsPageRepository
    self.tvShowsRepository = tvShowsRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    return tvShowsRepository.fetchPopularShows(page: requestValue.page)
  }

  func execute2(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return tvShowsPageRepository.fetchPopularShows(page: requestValue.page)
  }
}
