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

  init(accountRepository: AccountRepository) {
    self.accountRepository = accountRepository
  }

  func execute() -> AnyPublisher<Account, DataTransferError> {
    return accountRepository.getAccountDetails()
  }
}
