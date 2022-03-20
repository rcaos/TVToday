//
//  TVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Combine
import NetworkingInterface

public protocol TVShowsRepository {
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func searchShowsFor(query: String, page: Int) -> Observable<TVShowResult>

  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult>
}
