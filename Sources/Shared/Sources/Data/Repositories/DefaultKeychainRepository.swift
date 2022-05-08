//
//  DefaultKeychainRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import KeyChainStorage

public class DefaultKeychainRepository {

  private let keyChainStorage: KeychainStorage

  public init(keyChainStorage: KeychainStorage = DefaultKeyChainStorage.shared) {
    self.keyChainStorage = keyChainStorage
  }
}

// MARK: - KeychainStorage

extension DefaultKeychainRepository: KeychainRepository {

  public func saveRequestToken(_ token: String) {
    keyChainStorage.saveRequestToken(token)
  }

  public func fetchRequestToken() -> String? {
    return keyChainStorage.fetchRequestToken()
  }

  public func saveAccessToken(_ token: String) {
    keyChainStorage.saveAccessToken(token)
  }

  public func fetchAccessToken() -> String? {
    return keyChainStorage.fetchAccessToken()
  }

  public func saveLoguedUser(_ accountId: Int, _ sessionId: String) {
    keyChainStorage.saveLoguedUser(accountId, sessionId)
  }

  public func fetchLoguedUser() -> AccountDomain? {
    return keyChainStorage.fetchLoguedUser().map {
      AccountDomain(id: $0.id, sessionId: $0.sessionId)
    }
  }

  public func deleteLoguedUser() {
    keyChainStorage.deleteLoguedUser()
  }
}
