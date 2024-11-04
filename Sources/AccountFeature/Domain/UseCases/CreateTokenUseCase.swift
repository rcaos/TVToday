//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation

protocol CreateTokenUseCase {
  func execute() async -> URL?
}

final class DefaultCreateTokenUseCase: CreateTokenUseCase {
  private let authRepository: AuthRepository

  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }

  func execute() async -> URL? {
    return await authRepository.requestToken()?.url
  }
}
