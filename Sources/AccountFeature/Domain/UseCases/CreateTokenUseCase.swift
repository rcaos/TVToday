//
//  CreateTokenUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine
import Shared
import NetworkingInterface

protocol CreateTokenUseCase {
  func execute() -> AnyPublisher<URL, DataTransferError>
}

final class DefaultCreateTokenUseCase: CreateTokenUseCase {
  private let authRepository: AuthRepository

  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  func execute() -> AnyPublisher<URL, DataTransferError> {
    authRepository.requestToken()
      .map {
        return $0.url
      }
      .eraseToAnyPublisher()
  }
}
