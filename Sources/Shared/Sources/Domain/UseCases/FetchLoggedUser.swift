//
//  FetchLoggedUser.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

public protocol FetchLoggedUser {
  func execute() -> AccountDomain?
}

public final class DefaultFetchLoggedUser: FetchLoggedUser {

  private let keychainRepository: KeychainRepository

  public init(keychainRepository: KeychainRepository) {
    self.keychainRepository = keychainRepository
  }

  public func execute() -> AccountDomain? {
    return keychainRepository.fetchLoguedUser()
  }
}
