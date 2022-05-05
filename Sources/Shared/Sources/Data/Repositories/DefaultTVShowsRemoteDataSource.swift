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

  public func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/account/\(userId)/favorite/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/account/\(userId)/watchlist/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )

    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func markAsFavorite(tvShowId: Int, userId: String, session: String, favorite: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowActionStatusDTO>(
      path: "3/account/\(userId)/favorite",
      method: .post,
      queryParameters: [
        "session_id": session
      ],
      bodyParameters: [
        "media_type": "tv",
        "media_id": tvShowId,
        "favorite": favorite
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowActionStatusDTO>(
      path: "3/account/\(userId)/watchlist",
      method: .post,
      queryParameters: [
        "session_id": session
      ],
      bodyParameters: [
        "media_type": "tv",
        "media_id": tvShowId,
        "watchlist": watchedList
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchTVShowStatus(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStatusDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowAccountStatusDTO>(
      path: "3/tv/\(String(tvShowId))/account_states",
      method: .get,
      queryParameters: [
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }

  public func fetchGenres() -> AnyPublisher<GenreListDTO, DataTransferError> {
    let endpoint = Endpoint<GenreListDTO>(
      path: "3/genre/tv/list",
      method: .get
    )
    return dataTransferService.request(with: endpoint)
  }
}
