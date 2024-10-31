//
//  Created by Jeans Ruiz on 5/05/22.
//

import Networking
import NetworkingInterface

public final class DefaultTVEpisodesRemoteDataSource {
  private let apiClient: ApiClient

  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }
}

extension DefaultTVEpisodesRemoteDataSource: TVEpisodesRemoteDataSource {
  public func fetchEpisodes(for showId: Int, season: Int) async throws -> TVShowSeasonDTO {
    let endpoint = Endpoint(
      path: "3/tv/\(showId)/season/\(season)",
      method: .get
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowSeasonDTO.self)
  }
}
