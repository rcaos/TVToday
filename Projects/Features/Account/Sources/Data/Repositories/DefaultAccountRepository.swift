//
//  DefaultAccountRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Networking
import Shared

public final class DefaultAccountRepository {

  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - AuthRepository
extension DefaultAccountRepository: AccountRepository {
  public func getAccountDetails(session: String) -> Observable<AccountResult> {
    let endPoint = AccountProvider.accountDetails(sessionId: session)
    return dataTransferService.request(endPoint, AccountResult.self)
  }
}
