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
  private let loggedRepository: LoggedUserRepositoryProtocol

  public init(loggedRepository: LoggedUserRepositoryProtocol) {
    self.loggedRepository = loggedRepository
  }

  public func execute() -> AccountDomain? {
    return loggedRepository.getUser() // MARK: - TODO, Show Details access 3 times?
  }
}
