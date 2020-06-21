//
//  FetchAccountDetailsUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchAccountDetailsUseCase {
  // TODO don't drive struct to View Model
  func execute(session: String) -> Observable<Account>
}

final class DefaultFetchAccountDetailsUseCase: FetchAccountDetailsUseCase {
  
  private let accountRepository: AccountRepository
  
  init(accountRepository: AccountRepository) {
    self.accountRepository = accountRepository
  }
  
  func execute(session: String) -> Observable<Account> {
    return accountRepository.getAccountDetails(session: session)
  }
}
