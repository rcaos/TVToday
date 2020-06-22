//
//  DefaultAccountRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultAccountRepository {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - AuthRepository

extension DefaultAccountRepository: AccountRepository {
  func getAccountDetails(session: String) -> Observable<AccountResult> {
    let endPoint = AccountProvider.accountDetails(sessionId: session)
    return dataTransferService.request(endPoint, AccountResult.self)
  }
}
