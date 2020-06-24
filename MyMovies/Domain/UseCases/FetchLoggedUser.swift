//
//  FetchLoggedUser.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchLoggedUser {
  
  func execute() -> Account?
}

final class DefaultFetchLoggedUser: FetchLoggedUser {
  
  private let keychainRepository: KeychainRepository
  
  init(keychainRepository: KeychainRepository) {
    self.keychainRepository = keychainRepository
  }
  
  func execute() -> Account? {
    return keychainRepository.fetchLoguedUser()
  }
}
