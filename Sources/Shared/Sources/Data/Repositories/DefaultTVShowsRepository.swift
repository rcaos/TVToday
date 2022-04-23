//
//  DefaultTVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Networking

public final class DefaultTVShowsRepository {
  private let dataTransferService: DataTransferService

  private let basePath: String?

  public init(dataTransferService: DataTransferService, basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - TVShowsRepository
extension DefaultTVShowsRepository: TVShowsRepository {

  public func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError> {
    let endpoint = Endpoint<TVShowResult>(
      path: "3/tv/airing_today",
      method: .get,
      queryParameters: ["page": page]
    )
    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  public func fetchPopularShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError> {
    let endpoint = Endpoint<TVShowResult>(
      path: "3/tv/popular",
      method: .get,
      queryParameters: ["page": page]
    )
    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  public func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowResult, DataTransferError> {
    let endpoint = Endpoint<TVShowResult>(
      path: "3/discover/tv",
      method: .get,
      queryParameters: [
        "with_genres": genreId,
        "page": page,
        "sort_by": "popularity.desc",
        "timezone": "America%2FNew_York",
        "include_null_first_air_dates": "false"
      ]
    )

    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  public func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowResult, DataTransferError> {
    let endpoint = Endpoint<TVShowResult>(
      path: "3/search/tv",
      method: .get,
      queryParameters: [
        "query": query,
        "page": page
      ]
    )
    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  // MARK: - Map responses with ImageBase URL
  private func mapShowDetailsWithBasePath(response: TVShowResult) -> TVShowResult {
    guard let basePath = basePath else { return response }

    var newResponse = response

    newResponse.results = response.results.map { (show: TVShow) -> TVShow in
      var mutableShow = show
      mutableShow.backDropPath = basePath + "/t/p/w780" + ( show.backDropPath ?? "" )
      mutableShow.posterPath = basePath + "/t/p/w780" + ( show.posterPath ?? "" )
      return mutableShow
    }

    return newResponse
  }

  // MARK: - Fetch TVShow Details
  public func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailResult, DataTransferError> {
    let endpoint = Endpoint<TVShowDetailResult>(
      path: "3/tv/\(showId)",
      method: .get
    )

    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  private func mapShowDetailsWithBasePath(response: TVShowDetailResult) -> TVShowDetailResult {
    guard let basePath = basePath else { return response }

    var newResponse = response
    newResponse.backDropPath = basePath + "/t/p/w780" + ( response.backDropPath ?? "" )
    newResponse.posterPath = basePath + "/t/p/w780" + ( response.posterPath ?? "" )
    return newResponse
  }
}
