//
//  DefaultAccountRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import Networking
import NetworkingInterface

final class DefaultAccountRemoteDataSource: AccountRemoteDataSource {
  private let dataTransferService: DataTransferService
  private let apiClient: ApiClient

  init(dataTransferService: DataTransferService, apiClient: ApiClient) {
    self.dataTransferService = dataTransferService
    self.apiClient = apiClient
  }
  
  func getAccountDetails(session: String) -> AnyPublisher<AccountDTO, DataTransferError> {
    let endpoint = Networking.Endpoint<AccountDTO>(
      path: "3/account",
      method: .get,
      queryParameters: [
        "session_id": session
      ]
    )
    return dataTransferService.request(with: endpoint)
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
