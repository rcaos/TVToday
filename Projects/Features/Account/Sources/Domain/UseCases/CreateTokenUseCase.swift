//
//  CreateTokenUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import Shared

protocol CreateTokenUseCase {
  func execute() -> Observable<URL>
}

final class DefaultCreateTokenUseCase: CreateTokenUseCase {

  private let authRepository: AuthRepository

  private let keyChainRepository: KeychainRepository

  init(authRepository: AuthRepository, keyChainRepository: KeychainRepository) {
    self.authRepository = authRepository
    self.keyChainRepository = keyChainRepository
  }

  func execute() -> Observable<URL> {
    return
      authRepository.requestToken()
        .map { [weak self] in
          guard let token = $0.token else { throw CustomError.genericError }
          guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(token)") else { throw CustomError.genericError }
          self?.keyChainRepository.saveRequestToken(token)
          return url
    }
  }
}
