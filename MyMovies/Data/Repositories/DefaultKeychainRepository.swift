//
//  DefaultKeychainRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

class DefaultKeychainRepository {
  
  private var keyChainStorage: KeychainStorage
  
  init(keyChainStorage: KeychainStorage = DefaultKeyChainStorage.shared) {
    self.keyChainStorage = keyChainStorage
  }
}

// MARK: - KeychainStorage

extension DefaultKeychainRepository: KeychainRepository {
  
  func saveRequestToken(_ token: String) {
    keyChainStorage.saveRequestToken(token)
  }
  
  func fetchRequestToken() -> String? {
    return keyChainStorage.fetchRequestToken()
  }
  
  func saveAccessToken(_ token: String) {
    keyChainStorage.saveAccessToken(token)
  }
  
  func fetchAccessToken() -> String? {
    return keyChainStorage.fetchAccessToken()
  }
  
  func saveLoguedUser(_ accountId: Int, _ sessionId: String) {
    keyChainStorage.saveLoguedUser(accountId, sessionId)
  }
  
  func fetchLoguedUser() -> Account? {
    return keyChainStorage.fetchLoguedUser()
  }
  
  func deleteLoguedUser() {
    keyChainStorage.deleteLoguedUser()
  }
  
}
