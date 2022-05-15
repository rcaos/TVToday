//
//  LoggedUserLocalDataSource.swift
//  
//
//  Created by Jeans Ruiz on 12/05/22.
//

import Foundation

public protocol LoggedUserLocalDataSource {
  func saveUser(userId: Int, sessionId: String)
  func getUser() -> AccountDomain?  // MARK: - TODO, change by DTO
  func deleteUser()
}
