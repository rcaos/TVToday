//
//  DefaultKeychainStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

// MARK: - TODO, include protocol asDomain()

public struct AccountKStorage {
  public let id: Int

  public let sessionId: String
}

public class DefaultKeyChainStorage {
  static public let shared = DefaultKeyChainStorage()

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

  public func saveRequestToken(_ token: String) {
    requestToken = token
  }

  public func fetchRequestToken() -> String? {
    return requestToken
  }

  public func saveAccessToken(_ token: String) {
    accessToken = token
  }

  public func fetchAccessToken() -> String? {
    return accessToken
  }

  public func saveLoguedUser(_ accountId: Int, _ sessionId: String) {
    self.accountId = String(accountId)
    self.sessionId = sessionId
  }

  public func fetchLoguedUser() -> AccountKStorage? {
    guard let currentAccountId = accountId,
      let accountId = Int(currentAccountId),
      let sessionId = sessionId else { return nil }
    return AccountKStorage(id: accountId, sessionId: sessionId)
  }

  public func deleteLoguedUser() {
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
