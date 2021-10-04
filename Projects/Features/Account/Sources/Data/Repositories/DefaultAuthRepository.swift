//
//  DefaultAuthRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Networking

final class DefaultAuthRepository {

  private let dataTransferService: DataTransferService

  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - AuthRepository
extension DefaultAuthRepository: AuthRepository {

  func requestToken() -> Observable<CreateTokenResult> {
    let endPoint = AuthProvider.createRequestToken
    return dataTransferService.request(endPoint, CreateTokenResult.self)
  }

  func createSession(requestToken: String) -> Observable<CreateSessionResult> {
    let endPoint = AuthProvider.createSession(requestToken: requestToken)
    return dataTransferService.request(endPoint, CreateSessionResult.self)
  }
}
