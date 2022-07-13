//
//  DefaultAccountRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine
import NetworkingInterface
import Networking
import Shared

public final class DefaultAccountRepository {
  private let remoteDataSource: AccountRemoteDataSource
  private let accessTokenRepository: AccessTokenRepositoryProtocol
  private let userLoggedRepository: LoggedUserRepositoryProtocol
  private let gravatarBaseURL: String

  init(remoteDataSource: AccountRemoteDataSource, accessTokenRepository: AccessTokenRepositoryProtocol,
       userLoggedRepository: LoggedUserRepositoryProtocol,
       gravatarBaseURL: String) {
    self.remoteDataSource = remoteDataSource
    self.accessTokenRepository = accessTokenRepository
    self.userLoggedRepository = userLoggedRepository
    self.gravatarBaseURL = gravatarBaseURL
  }
}

// MARK: - AccountRepository
extension DefaultAccountRepository: AccountRepository {

  public func getAccountDetails() -> AnyPublisher<Account, DataTransferError> {
    let sessionId = accessTokenRepository.getAccessToken()

    return remoteDataSource.getAccountDetails(session: sessionId)
      .map {
        self.userLoggedRepository.saveUser(userId: $0.id, sessionId: sessionId)
        let avatarURL = URL(string: "\(self.gravatarBaseURL)/\($0.avatar?.gravatar?.hash ?? "" )")
        return Account(id: $0.id, userName: $0.userName, avatarURL: avatarURL)
      }
      .eraseToAnyPublisher()
  }
}
