//
//  LoggedUserRepositoryProtocol.swift
//  
//
//  Created by Jeans Ruiz on 12/05/22.
//

import Foundation

public protocol LoggedUserRepositoryProtocol {
  func saveUser(userId: Int, sessionId: String) // MARK: - TODO, use userId as String
  func getUser() -> AccountDomain?
  func deleteUser()
}
