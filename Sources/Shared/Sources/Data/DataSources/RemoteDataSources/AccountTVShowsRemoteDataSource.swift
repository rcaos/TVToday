//
//  Created by Jeans Ruiz on 13/05/22.
//

import Networking
import NetworkingInterface

public class AccountTVShowsRemoteDataSource {
  private let apiClient: ApiClient

  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }
}

extension AccountTVShowsRemoteDataSource: AccountTVShowsRemoteDataSourceProtocol {
  public func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) async throws -> TVShowPageDTO {
    let endpoint = Endpoint(
      path: "3/account/\(userId)/favorite/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowPageDTO.self)
  }

  public func fetchWatchListShows(page: Int, userId: Int, sessionId: String) async throws -> TVShowPageDTO {
    let endpoint = Endpoint(
      path: "3/account/\(userId)/watchlist/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowPageDTO.self)
  }
}
