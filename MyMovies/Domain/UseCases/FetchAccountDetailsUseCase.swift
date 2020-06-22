//
//  FetchAccountDetailsUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchAccountDetailsUseCase {
  func execute() -> Observable<AccountResult>
}

final class DefaultFetchAccountDetailsUseCase: FetchAccountDetailsUseCase {
  
  private let accountRepository: AccountRepository
  
  private let keychainRepository: KeychainRepository
  
  init(accountRepository: AccountRepository,
       keychainRepository: KeychainRepository) {
    self.accountRepository = accountRepository
    self.keychainRepository = keychainRepository
  }
  
  func execute() -> Observable<AccountResult> {
    
    guard let sessionId = keychainRepository.fetchAccessToken() else {
      return Observable.error(CustomError.genericError)
    }
    
    return accountRepository.getAccountDetails(session: sessionId)
      .flatMap { [weak self] accountResult -> Observable<AccountResult> in
        guard let fetchedAccount = accountResult.id else { throw CustomError.genericError }
        self?.keychainRepository.saveLoguedUser(fetchedAccount, sessionId)
        return Observable.just(accountResult)
    }
  }
}
