//
//  Created by Jeans Ruiz on 6/21/20.
//

import Combine
import NetworkingInterface
import Shared

protocol CreateSessionUseCase {
  func execute() -> AnyPublisher<Void, DataTransferError>
  func execute() async -> Bool
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

  func execute() async -> Bool {
    return await authRepository.createSession()?.success == true
  }
}
