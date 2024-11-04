//
//  Created by Jeans Ruiz on 13/05/22.
//

import Networking
import NetworkingInterface

public class AccountTVShowsDetailsRemoteDataSource {
  private let apiClient: ApiClient

  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }
}

extension AccountTVShowsDetailsRemoteDataSource: AccountTVShowsDetailsRemoteDataSourceProtocol {
  public func markAsFavorite(tvShowId: Int, userId: String, session: String, favorite: Bool) async throws -> TVShowActionStatusDTO {
    let endpoint = Endpoint(
      path: "3/account/\(userId)/favorite",
      method: .post,
      queryParameters: [
        "session_id": session
      ],
      bodyParamaters: [
        "media_type": "tv",
        "media_id": tvShowId,
        "favorite": favorite
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowActionStatusDTO.self)
  }

  public func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) async throws -> TVShowActionStatusDTO {
    let endpoint = Endpoint(
      path: "3/account/\(userId)/watchlist",
      method: .post,
      queryParameters: [
        "session_id": session
      ],
      bodyParamaters: [
        "media_type": "tv",
        "media_id": tvShowId,
        "watchlist": watchedList
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowActionStatusDTO.self)
  }

  public func fetchTVShowStatus(tvShowId: Int, sessionId: String) async throws -> TVShowAccountStatusDTO {
    let endpoint = Endpoint(
      path: "3/tv/\(String(tvShowId))/account_states",
      method: .get,
      queryParameters: [
        "session_id": sessionId
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowAccountStatusDTO.self)
  }
}
