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

  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  func execute() -> AnyPublisher<Void, DataTransferError> {
    return authRepository.createSession()
      .map { _ in
        return (())
      }
      .eraseToAnyPublisher()
  }
}
