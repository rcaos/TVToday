//
//  DeleteLoguedUserUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Shared

protocol DeleteLoguedUserUseCase {
  func execute()
}

final class DefaultDeleteLoguedUserUseCase: DeleteLoguedUserUseCase {
  private let keychainRepository: KeychainRepository
  
  init(keychainRepository: KeychainRepository) {
    self.keychainRepository = keychainRepository
  }
  
  func execute() {
    return keychainRepository.deleteLoguedUser()
  }
}
