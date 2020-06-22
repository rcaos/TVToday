//
//  DefaultKeychainStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

class DefaultKeyChainStorage {
  static let shared = DefaultKeyChainStorage()
  
  @KeychainItemStorage(key: Constants.requestTokenKey)
  var requestToken: String?
  
  @KeychainItemStorage(key: Constants.accessToken)
  var accessToken: String?
  
  @KeychainItemStorage(key: Constants.accountId)
  var accountId: String?
  
  @KeychainItemStorage(key: Constants.sessionId)
  var sessionId: String?
  
  init() {}
}

// MARK: - KeychainStorage

extension DefaultKeyChainStorage: KeychainStorage {

  func saveRequestToken(_ token: String) {
    requestToken = token
  }
  
  func fetchRequestToken() -> String? {
    return requestToken
  }
  
  func saveAccessToken(_ token: String) {
    accessToken = token
  }
  
  func fetchAccessToken() -> String? {
    return accessToken
  }
  
  func saveLoguedUser(_ accountId: Int, _ sessionId: String) {
    print("Save in KeyChain User:: [\(accountId),\(sessionId)]")
    self.accountId = String(accountId)
    self.sessionId = sessionId
  }
  
  func fetchLoguedUser() -> Account? {
    guard let currentAccountId = accountId,
      let accountId = Int(currentAccountId),
      let sessionId = sessionId else { return nil }
    return Account(id: accountId, sessionId: sessionId)
  }
  
  func deleteLoguedUser() {
    accountId = nil
    sessionId = nil
  }
  
}

// MARK: - Constants

extension DefaultKeyChainStorage {
  struct Constants {
    static let requestTokenKey = "TVShows_RequestToken"
    static let accessToken = "TVShows_accessToken"
    static let accountId = "TVShows_AccountId"
    static let sessionId = "TVShows_SessionId"
  }
}
