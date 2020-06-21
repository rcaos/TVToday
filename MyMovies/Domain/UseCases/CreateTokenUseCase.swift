//
//  CreateTokenUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol CreateTokenUseCase {
  func execute() -> Observable<(URL, String)>
}

final class DefaultCreateTokenUseCase: CreateTokenUseCase {
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func execute() -> Observable<(URL, String)> {
    return
      authRepository.requestToken()
        .map {
          guard let token = $0.token else { throw CustomError.genericError }
          guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(token)") else { throw CustomError.genericError }
          return (url, token)
    }
  }
}

enum CustomError: Error {
  case genericError
}
