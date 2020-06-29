//
//  SearchTVShowsUseCase.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import RxSwift
import Shared

public protocol SearchTVShowsUseCase {
  
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> Observable<TVShowResult>
}

public struct SearchTVShowsUseCaseRequestValue {
  public let query: String
  public let page: Int
}

// MARK: - SearchTVShowsUseCase

final class DefaultSearchTVShowsUseCase: SearchTVShowsUseCase {
  
  private let tvShowsRepository: TVShowsRepository
  
  public init(tvShowsRepository: TVShowsRepository) {
    self.tvShowsRepository = tvShowsRepository
  }
  
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    return tvShowsRepository.searchShowsFor(query: requestValue.query,
                                            page: requestValue.page)
  }
  
}
