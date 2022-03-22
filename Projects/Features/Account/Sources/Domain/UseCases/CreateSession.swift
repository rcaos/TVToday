//
//  CreateSession.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Shared

protocol CreateSessionUseCase {
  func execute() -> AnyPublisher<Void, DataTransferError>
}

final class DefaultCreateSessionUseCase: CreateSessionUseCase {
  private let authRepository: AuthRepository
  private let keyChainRepository: KeychainRepository

  init(authRepository: AuthRepository, keyChainRepository: KeychainRepository) {
    self.authRepository = authRepository
    self.keyChainRepository = keyChainRepository
  }

  func execute() -> AnyPublisher<Void, DataTransferError> {
    guard let requestToken = keyChainRepository.fetchRequestToken() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
    }

    return authRepository.createSession(requestToken: requestToken)
      .flatMap { [weak self] sessionResult -> AnyPublisher<Void, DataTransferError> in
        guard let sessionId = sessionResult.sessionId else {
          return Fail(error: DataTransferError.noResponse)
            .eraseToAnyPublisher()
        }

        self?.keyChainRepository.saveAccessToken(sessionId)

        return Just(())
          .setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
