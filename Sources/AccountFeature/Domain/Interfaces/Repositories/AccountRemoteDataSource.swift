//
//  File.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountRemoteDataSource {
  func getAccountDetails(session: String) -> AnyPublisher<AccountDTO, DataTransferError>
}
