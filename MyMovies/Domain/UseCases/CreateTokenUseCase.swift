//
//  CreateTokenUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol CreateTokenUseCase {
  func execute() -> Observable<CreateTokenResult>
}

final class DefaultCreateTokenUseCase: CreateTokenUseCase {
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func execute() -> Observable<CreateTokenResult> {
    return authRepository.requestToken()
  }
}
