//
//  TVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol TVShowsRepository {
  func fetchAiringTodayShows(page: Int) -> Observable<TVShowResult>

  func fetchPopularShows(page: Int) -> Observable<TVShowResult>

  func fetchShowsByGenre(genreId: Int, page: Int) -> Observable<TVShowResult>

  func searchShowsFor(query: String, page: Int) -> Observable<TVShowResult>

  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult>
}
