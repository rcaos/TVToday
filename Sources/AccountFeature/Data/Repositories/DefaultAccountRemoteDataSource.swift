//
//  Created by Jeans Ruiz on 7/05/22.
//

import NetworkingInterface

final class DefaultAccountRemoteDataSource: AccountRemoteDataSource {
  private let apiClient: ApiClient

  init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }

  func getAccountDetails(session: String) async throws -> AccountDTO {
    let endpoint = Endpoint(
      path: "3/account",
      method: .get,
      queryParameters: [
        "session_id": session
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: AccountDTO.self)
  }
}
