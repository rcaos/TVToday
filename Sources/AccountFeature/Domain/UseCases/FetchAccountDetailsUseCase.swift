//
//  FetchAccountDetailsUseCase.swift
//  AccountFeature
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared
import NetworkingInterface

protocol FetchAccountDetailsUseCase {
  func execute() -> AnyPublisher<Account, DataTransferError>
}

final class DefaultFetchAccountDetailsUseCase: FetchAccountDetailsUseCase {
  private let accountRepository: AccountRepository
  private let keychainRepository: KeychainRepository

  init(accountRepository: AccountRepository,
       keychainRepository: KeychainRepository) {
    self.accountRepository = accountRepository
    self.keychainRepository = keychainRepository
  }

  func execute() -> AnyPublisher<Account, DataTransferError> {
    guard let sessionId = keychainRepository.fetchAccessToken() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
    }

    return accountRepository.getAccountDetails(session: sessionId)
      .flatMap { [weak self] account -> AnyPublisher<Account, DataTransferError> in
        self?.keychainRepository.saveLoguedUser(account.id, sessionId)
        return Just(account).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
