//
//  Created by Jeans Ruiz on 6/21/20.
//

import NetworkingInterface

protocol CreateSessionUseCase {
  func execute() async -> Bool
}

final class DefaultCreateSessionUseCase: CreateSessionUseCase {
  private let authRepository: AuthRepository

  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  func execute() async -> Bool {
    return await authRepository.createSession()?.success == true
  }
}
