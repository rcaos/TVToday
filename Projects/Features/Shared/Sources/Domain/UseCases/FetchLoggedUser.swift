//
//  FetchLoggedUser.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FetchLoggedUser {
  
  func execute() -> Account?
}

public final class DefaultFetchLoggedUser: FetchLoggedUser {
  
  private let keychainRepository: KeychainRepository
  
  public init(keychainRepository: KeychainRepository) {
    self.keychainRepository = keychainRepository
  }
  
  public func execute() -> Account? {
    return keychainRepository.fetchLoguedUser()
  }
}
