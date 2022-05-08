//
//  DefaultAccountRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import Networking
import NetworkingInterface

final class DefaultAccountRemoteDataSource: AccountRemoteDataSource {
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
  
  func getAccountDetails(session: String) -> AnyPublisher<AccountDTO, DataTransferError> {
    let endpoint = Endpoint<AccountDTO>(
      path: "3/account",
      method: .get,
      queryParameters: [
        "session_id": session
      ]
    )
    return dataTransferService.request(with: endpoint)
  }
}
