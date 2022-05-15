//
//  LoggedUserRepository.swift
//  
//
//  Created by Jeans Ruiz on 12/05/22.
//

import Foundation

public final class LoggedUserRepository {
  let dataSource: LoggedUserLocalDataSource

  public init(dataSource: LoggedUserLocalDataSource) {
    self.dataSource = dataSource
  }
}

extension LoggedUserRepository: LoggedUserRepositoryProtocol {

  public func saveUser(userId: Int, sessionId: String) {// MARK: - TODO, use userId as String
    dataSource.saveUser(userId: userId, sessionId: sessionId)
  }

  public func getUser() -> AccountDomain? {
    return dataSource.getUser()
  }

  public func deleteUser() {
    dataSource.deleteUser()
  }
}
