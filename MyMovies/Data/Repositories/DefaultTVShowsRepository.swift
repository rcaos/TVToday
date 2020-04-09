//
//  DefaultTVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultTVShowsRepository {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - TVShowsRepository

extension DefaultTVShowsRepository: TVShowsRepository {
  
  func fetchTVShowsList(with filter: TVShowsListFilter, page: Int) -> Observable<TVShowResult> {
    let endPoint = getProvider(with: filter, page: page)
    
    return dataTransferService.request(endPoint, TVShowResult.self)
  }
  
  private func getProvider(with filter: TVShowsListFilter, page: Int) -> TVShowsProvider {
    switch filter {
    case .today:
      return TVShowsProvider.getAiringTodayShows(page)
    case .popular:
      return TVShowsProvider.getPopularTVShows(page)
    case .byGenre(let genreId):
      return TVShowsProvider.listTVShowsBy(genreId, page)
    case .search(let query):
      return TVShowsProvider.searchTVShow(query, page)
    }
  }
}
