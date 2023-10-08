//
//  DefaultAuthRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import NetworkingInterface
import Networking

final class DefaultAuthRemoteDataSource: AuthRemoteDataSource {
  private let dataTransferService: DataTransferService
  private let apiClient: ApiClient

  init(dataTransferService: DataTransferService, apiClient: ApiClient) {
    self.apiClient = apiClient
    self.dataTransferService = dataTransferService
  }

  func requestToken() -> AnyPublisher<NewRequestTokenDTO, DataTransferError> {
    let endpoint = Networking.Endpoint<NewRequestTokenDTO>(
      path: "3/authentication/token/new",
      method: .get
    )
    return dataTransferService.request(with: endpoint)
  }

  func createSession(requestToken: String) -> AnyPublisher<NewSessionDTO, DataTransferError> {
    let endpoint = Networking.Endpoint<NewSessionDTO>(
      path: "3/authentication/session/new",
      method: .post,
      queryParameters: [
        "request_token": requestToken
      ]
    )
    return dataTransferService.request(with: endpoint)
  }

  func requestToken() async throws -> NewRequestTokenDTO {
    let endpoint = Endpoint(
      path: "3/authentication/token/new",
      method: .get
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: NewRequestTokenDTO.self)
  }

  func createSession(requestToken: String) async throws -> NewSessionDTO {
    let endpoint = Endpoint<NewSessionDTO>(
      path: "3/authentication/session/new",
      method: .post,
      queryParameters: [
        "request_token": requestToken
      ]
    )
    return try await apiClient.apiRequest(endpoint: endpoint, as: NewSessionDTO.self)
  }
}
