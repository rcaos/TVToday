//
//  Created by Jeans Ruiz on 7/05/22.
//

import NetworkingInterface

final class DefaultAuthRemoteDataSource: AuthRemoteDataSource {
  private let apiClient: ApiClient

  init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }

  func requestToken() async throws -> NewRequestTokenDTO {
    let endpoint = Endpoint(
      path: "3/authentication/token/new",
      method: .get
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: NewRequestTokenDTO.self)
  }

  func createSession(requestToken: String) async throws -> NewSessionDTO {
    let endpoint = Endpoint(
      path: "3/authentication/session/new",
      method: .post,
      queryParameters: [
        "request_token": requestToken
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: NewSessionDTO.self)
  }
}
