//
//  TVShowsRemoteDataSourceProtocol.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import NetworkingInterface

public protocol TVShowsRemoteDataSourceProtocol {
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
}
