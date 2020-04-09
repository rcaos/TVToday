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
}

// MARK: - TVShowsListFilter

enum TVShowsListFilter {
  
  case today, popular
  
  case byGenre(genreId: Int)
  
  case search(query: String)
}
