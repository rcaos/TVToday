//
//  DefaultTVShowsRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 30/04/22.
//

import Combine
import Networking
import NetworkingInterface

public final class DefaultTVShowsRemoteDataSource: TVShowsRemoteDataSource {
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }

  public func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/tv/airing_today",
      method: .get,
      queryParameters: ["page": page]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/tv/popular",
      method: .get,
      queryParameters: ["page": page]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/discover/tv",
      method: .get,
      queryParameters: [
        "with_genres": genreId,
        "page": page,
        "sort_by": "popularity.desc",
        "timezone": "America%2FNew_York", // MARK: - TODO, should be injected
        "include_null_first_air_dates": "false"
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/search/tv",
      method: .get,
      queryParameters: [
        "query": query,
        "page": page
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowDetailDTO>(
      path: "3/tv/\(showId)",
      method: .get
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }
}
