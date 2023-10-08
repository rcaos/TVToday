//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation
import Combine
import Shared
import NetworkingInterface

protocol CreateTokenUseCase {
  func execute() -> AnyPublisher<URL, DataTransferError>
  func execute() async -> URL?
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

  func execute() async -> URL? {
    return await authRepository.requestToken()?.url
  }
}
