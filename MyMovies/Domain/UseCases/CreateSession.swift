//
//  CreateSession.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol CreateSessionUseCase {
  // TODO don't drive struct to View Model
  func execute(requestToken: String) -> Observable<CreateSessionResult>
}

final class DefaultCreateSessionUseCase: CreateSessionUseCase {
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func execute(requestToken: String) -> Observable<CreateSessionResult> {
    return authRepository.createSession(requestToken: requestToken)
  }
}
