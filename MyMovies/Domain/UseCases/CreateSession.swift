//
//  CreateSession.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol CreateSessionUseCase {
  func execute() -> Observable<Void>
}

final class DefaultCreateSessionUseCase: CreateSessionUseCase {
  
  private let authRepository: AuthRepository
  
  private let keyChainRepository: KeychainRepository
  
  init(authRepository: AuthRepository, keyChainRepository: KeychainRepository) {
    self.authRepository = authRepository
    self.keyChainRepository = keyChainRepository
  }
  
  func execute() -> Observable<Void> {
    guard let requestToken = keyChainRepository.fetchRequestToken() else { return Observable.error(CustomError.genericError) }
    
    return authRepository.createSession(requestToken: requestToken)
      .flatMap { [weak self] sessionResult -> Observable<Void> in
        guard let sessionId = sessionResult.sessionId else { throw CustomError.genericError }
        
        self?.keyChainRepository.saveAccessToken(sessionId)
        return Observable.just(())
    }
  }
}
