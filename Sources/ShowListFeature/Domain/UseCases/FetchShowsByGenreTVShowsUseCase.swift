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
  private let tvShowsRepository: TVShowsRepository

  init(genreId: Int, tvShowsRepository: TVShowsRepository) {
    self.genreId = genreId
    self.tvShowsRepository = tvShowsRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    return tvShowsRepository.fetchShowsByGenre(genreId: genreId, page: requestValue.page)
  }
}
