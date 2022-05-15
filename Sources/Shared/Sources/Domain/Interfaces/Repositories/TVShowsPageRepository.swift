//
//  TVShowsPageRepository.swift
//  Shared
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

public protocol TVShowsPageRepository {
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
}
