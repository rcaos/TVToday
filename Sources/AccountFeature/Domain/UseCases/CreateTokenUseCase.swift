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
  private let keyChainRepository: KeychainRepository

  init(authRepository: AuthRepository, keyChainRepository: KeychainRepository) {
    self.authRepository = authRepository
    self.keyChainRepository = keyChainRepository
  }

  func execute() -> AnyPublisher<URL, DataTransferError> {
    authRepository.requestToken()
      .flatMap { [weak self] result -> AnyPublisher<URL, DataTransferError> in
        // MARK: - TODO, Move URL to environment config
        guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(result.token)") else {
          return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
        }

        self?.keyChainRepository.saveRequestToken(result.token)

        return Just(url).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
