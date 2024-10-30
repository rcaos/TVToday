//
//  Created by Jeans Ruiz on 30/04/22.
//

import Combine
import Networking
import NetworkingInterface

public final class DefaultTVShowsRemoteDataSource: TVShowsRemoteDataSourceProtocol {
  private let apiClient: ApiClient

  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }

  public func fetchAiringTodayShows(page: Int) async throws -> TVShowPageDTO {
    let endpoint = Endpoint(
      path: "3/tv/airing_today",
      method: .get,
      queryParameters: ["page": page]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowPageDTO.self)
  }

  public func fetchPopularShows(page: Int) async throws -> TVShowPageDTO {
    let endpoint = Endpoint(
      path: "3/tv/popular",
      method: .get,
      queryParameters: ["page": page]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowPageDTO.self)
  }

  public func fetchShowsByGenre(genreId: Int, page: Int) async throws -> TVShowPageDTO {
    let endpoint = Endpoint(
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
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowPageDTO.self)
  }

  public func searchShowsFor(query: String, page: Int) async throws -> TVShowPageDTO {
    let endpoint = Endpoint(
      path: "3/search/tv",
      method: .get,
      queryParameters: [
        "query": query,
        "page": page
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowPageDTO.self)
  }
}
