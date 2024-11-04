//
//  Created by Jeans Ruiz on 6/05/22.
//

import Networking
import NetworkingInterface

final class DefaultGenreRemoteDataSource: GenreRemoteDataSource {
  private let apiClient: ApiClient

  init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }

  func fetchGenres() async throws -> GenreListDTO {
    let endpoint = Endpoint(
      path: "3/genre/tv/list",
      method: .get
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: GenreListDTO.self)
  }
}
