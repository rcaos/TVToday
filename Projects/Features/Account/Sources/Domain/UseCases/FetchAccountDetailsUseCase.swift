//
//  FetchAccountDetailsUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared
import NetworkingInterface

protocol FetchAccountDetailsUseCase {
  func execute() -> AnyPublisher<AccountResult, DataTransferError>
}

final class DefaultFetchAccountDetailsUseCase: FetchAccountDetailsUseCase {
  private let accountRepository: AccountRepository
  private let keychainRepository: KeychainRepository

  init(accountRepository: AccountRepository,
       keychainRepository: KeychainRepository) {
    self.accountRepository = accountRepository
    self.keychainRepository = keychainRepository
  }

  func execute() -> AnyPublisher<AccountResult, DataTransferError> {
    guard let sessionId = keychainRepository.fetchAccessToken() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
    }

    // TODO
    return accountRepository.getAccountDetails(session: sessionId)
//      .flatMap { [weak self] accountResult -> Observable<AccountResult> in
//        guard let fetchedAccount = accountResult.id else { throw CustomError.genericError }
//        self?.keychainRepository.saveLoguedUser(fetchedAccount, sessionId)
//        return Observable.just(accountResult)
//    }
  }
}
