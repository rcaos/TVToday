//
//  FetchShowsMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FetchTVShowsUseCase {

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult>
}

public struct FetchTVShowsUseCaseRequestValue {
  public let page: Int
}

//// MARK: - DefaultFetchTodayShowsUseCase
//
//public final class DefaultFetchTVShowsUseCase: FetchTVShowsUseCase {
//
//  private let tvShowsRepository: TVShowsRepository
//
//  public init(filter: TVShowsListFilter, tvShowsRepository: TVShowsRepository) {
//    self.filter = filter
//    self.tvShowsRepository = tvShowsRepository
//  }
//
//  public func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
//    //let filter = requestValue.filter
//    // TODO
//    return tvShowsRepository.fetchShowsByGenre(genreId: 22, page: requestValue.page)
//    //return tvShowsRepository.fetchTVShowsList(with: filter, page: requestValue.page)
//  }
//}
