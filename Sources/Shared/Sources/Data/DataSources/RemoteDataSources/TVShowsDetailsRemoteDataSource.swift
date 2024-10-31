//
//  Created by Jeans Ruiz on 13/05/22.
//

import Networking
import NetworkingInterface

public final class TVShowsDetailsRemoteDataSource: TVShowsDetailsRemoteDataSourceProtocol {
  private let apiClient: ApiClient

  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }

  public func fetchTVShowDetails(with showId: Int) async throws ->TVShowDetailDTO {
    let endpoint = Endpoint(
      path: "3/tv/\(showId)",
      method: .get
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: TVShowDetailDTO.self)
  }
}
