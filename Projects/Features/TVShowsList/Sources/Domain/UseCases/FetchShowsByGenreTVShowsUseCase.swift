//
//  FetchShowsByGenreTVShowsUseCase.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import RxSwift
import Shared

final class DefaultFetchShowsByGenreTVShowsUseCase: FetchTVShowsUseCase {
  
  private let genreId: Int
  private let tvShowsRepository: TVShowsRepository
  
  init(genreId: Int, tvShowsRepository: TVShowsRepository) {
    self.genreId = genreId
    self.tvShowsRepository = tvShowsRepository
  }
  
  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    return tvShowsRepository.fetchShowsByGenre(genreId: genreId, page: requestValue.page)
  }
}
