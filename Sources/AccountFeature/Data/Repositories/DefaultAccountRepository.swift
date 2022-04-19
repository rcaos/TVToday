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
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - AuthRepository
extension DefaultAccountRepository: AccountRepository {

  public func getAccountDetails(session: String) -> AnyPublisher<AccountResult, DataTransferError> {
    let endpoint = Endpoint<AccountResult>(
      path: "3/account",
      method: .get,
      queryParameters: [
        "session_id": session
      ]
    )
    return dataTransferService.request(with: endpoint)
  }
}
