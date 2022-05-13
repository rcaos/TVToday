//
//  DefaultKeychainStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Shared

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

  public init() {}
}

// MARK: - Constants
struct Constants {
  static let requestTokenKey = "TVShows_RequestToken"
  static let accessToken = "TVShows_accessToken"
  static let accountId = "TVShows_AccountId"
  static let sessionId = "TVShows_SessionId"
}

extension DefaultKeyChainStorage: RequestTokenLocalDataSource {
  public func saveRequestToken(_ token: String) {
    requestToken = token
  }

  public func getRequestToken() -> String? {
    return requestToken
  }
}

extension DefaultKeyChainStorage: AccessTokenLocalDataSource {
  public func saveAccessToken(_ token: String) {
    accessToken = token
  }

  public func getAccessToken() -> String {
    return accessToken ?? ""
  }
}

extension DefaultKeyChainStorage: LoggedUserLocalDataSource {
  public func saveUser(userId: Int, sessionId: String) {
    self.accountId = String(userId)
    self.sessionId = sessionId
  }

  public func getUser() -> AccountDomain? {
    guard let currentAccountId = accountId,
          let accountId = Int(currentAccountId),
          let sessionId = sessionId else { return nil }
    return AccountDomain(id: accountId, sessionId: sessionId)
  }

  public func deleteUser() {
    accountId = nil
    sessionId = nil
  }
}
