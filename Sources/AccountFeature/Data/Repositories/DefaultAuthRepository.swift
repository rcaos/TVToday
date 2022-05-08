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
  private let remoteDataSource: AuthRemoteDataSource

  init(remoteDataSource: AuthRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
}

// MARK: - AuthRepository
extension DefaultAuthRepository: AuthRepository {

  func requestToken() -> AnyPublisher<NewRequestToken, DataTransferError> {
    return remoteDataSource.requestToken()
      .map {
        return NewRequestToken(success: $0.success, token: $0.token)
      }
      .eraseToAnyPublisher()
  }

  func createSession(requestToken: String) -> AnyPublisher<NewSession, DataTransferError> {
    return remoteDataSource.createSession(requestToken: requestToken)
      .map {
        return NewSession(success: $0.success, sessionId: $0.sessionId)
      }
      .eraseToAnyPublisher()
  }
}
