//
//  TVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol TVShowsRepository {
  
  func fetchTVShowsList(with filter: TVShowsListFilter,
                        page: Int) -> Observable<TVShowResult>
  
  func fetchTVAccountStates(tvShowId: Int, sessionId: String) -> Observable<TVShowAccountStateResult>
  
  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult>
}

// MARK: - TVShowsListFilter

enum TVShowsListFilter {
  
  case today, popular
  
  case byGenre(genreId: Int)
  
  case search(query: String)
  
  case favorites(userId: Int, sessionId: String)
  
  case watchList(userId: Int, sessionId: String)
}
