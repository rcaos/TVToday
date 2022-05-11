//
//  DeleteLoggedUserUseCase.swift
//  AccountFeature
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Shared

protocol DeleteLoggedUserUseCase {
  func execute()
}

final class DefaultDeleteLoggedUserUseCase: DeleteLoggedUserUseCase {
  private let loggedRepository: LoggedUserRepositoryProtocol

  init(loggedRepository: LoggedUserRepositoryProtocol) {
    self.loggedRepository = loggedRepository
  }

  func execute() {
    loggedRepository.deleteUser()
  }
}
