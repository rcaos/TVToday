//
//  DefaultFetchPopularTVShowsUseCase.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import RxSwift
import Shared

final class DefaultFetchPopularTVShowsUseCase: FetchTVShowsUseCase {
  
  private let tvShowsRepository: TVShowsRepository
    
  init(tvShowsRepository: TVShowsRepository) {
    self.tvShowsRepository = tvShowsRepository
  }
  
  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    return tvShowsRepository.fetchPopularShows(page: requestValue.page)
  }
}
