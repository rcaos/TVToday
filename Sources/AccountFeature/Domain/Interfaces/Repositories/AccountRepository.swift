//
//  AccountRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

public protocol AccountRepository {
  func getAccountDetails() -> AnyPublisher<Account, DataTransferError>
}
