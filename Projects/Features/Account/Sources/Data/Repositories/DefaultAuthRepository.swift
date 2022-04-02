//
//  DefaultAuthRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Networking

final class DefaultAuthRepository {

  private let dataTransferService: DataTransferService

  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - AuthRepository
extension DefaultAuthRepository: AuthRepository {

  func requestToken() -> AnyPublisher<CreateTokenResult, DataTransferError> {
    let endpoint = Endpoint<CreateTokenResult>(
      path: "3/authentication/token/new",
      method: .get
    )
    return dataTransferService.request(with: endpoint)
  }

  func createSession(requestToken: String) -> AnyPublisher<CreateSessionResult, DataTransferError> {
    let endpoint = Endpoint<CreateSessionResult>(
      path: "3/authentication/session/new",
      method: .post,
      queryParameters: [
        "request_token": requestToken
      ]
    )
    return dataTransferService.request(with: endpoint)
  }
}
