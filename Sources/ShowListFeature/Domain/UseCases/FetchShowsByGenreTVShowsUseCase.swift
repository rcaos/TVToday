//
//  FetchShowsByGenreTVShowsUseCase.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Shared
import NetworkingInterface

final class DefaultFetchShowsByGenreTVShowsUseCase: FetchTVShowsUseCase {
  private let genreId: Int
  private let tvShowsPageRepository: TVShowsPageRepository

  init(genreId: Int, tvShowsPageRepository: TVShowsPageRepository) {
    self.genreId = genreId
    self.tvShowsPageRepository = tvShowsPageRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return tvShowsPageRepository.fetchShowsByGenre(genreId: genreId, page: requestValue.page)
  }
}
