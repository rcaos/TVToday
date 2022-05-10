//
//  DefaultAccountRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Networking
import Shared

public final class DefaultAccountRepository {
  private let remoteDataSource: AccountRemoteDataSource
  private let tokenRepository: AccessTokenRepository
  private let userLoggedRepository: LoggedUserRepository

  init(remoteDataSource: AccountRemoteDataSource, tokenRepository: AccessTokenRepository, userLoggedRepository: LoggedUserRepository) {
    self.remoteDataSource = remoteDataSource
    self.tokenRepository = tokenRepository
    self.userLoggedRepository = userLoggedRepository
  }
}

// MARK: - AccountRepository
extension DefaultAccountRepository: AccountRepository {

  public func getAccountDetails() -> AnyPublisher<Account, DataTransferError> {
    let sessionId = tokenRepository.getAccessToken()

    return remoteDataSource.getAccountDetails(session: sessionId)
      .map {
        self.userLoggedRepository.saveUser(userId: $0.id, sessionId: sessionId)
        let avatar = Avatar(hashId: $0.avatar?.gravatar?.hash)
        return Account(id: $0.id, userName: $0.userName, avatar: avatar)
      }
      .eraseToAnyPublisher()
  }
}
