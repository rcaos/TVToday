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

public final class DefaultAccountRepository {
  private let remoteDataSource: AccountRemoteDataSource

  init(remoteDataSource: AccountRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
}

// MARK: - AccountRepository
extension DefaultAccountRepository: AccountRepository {

  public func getAccountDetails(session: String) -> AnyPublisher<Account, DataTransferError> {
    return remoteDataSource.getAccountDetails(session: session)
      .map {
        let avatar = Avatar(hashId: $0.avatar?.gravatar?.hash)
        return Account(id: $0.id, userName: $0.userName, avatar: avatar)
      }
      .eraseToAnyPublisher()
  }
}
