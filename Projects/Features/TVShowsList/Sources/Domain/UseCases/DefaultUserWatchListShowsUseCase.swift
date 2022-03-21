//
//  DefaultUserWatchListShowsUseCase.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import Shared
import NetworkingInterface

public final class DefaultUserWatchListShowsUseCase: FetchTVShowsUseCase {
  private let accountShowsRepository: AccountTVShowsRepository

  private let keychainRepository: KeychainRepository

  public init(accountShowsRepository: AccountTVShowsRepository, keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }

  public func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    guard let userLogged = keychainRepository.fetchLoguedUser() else {
      return Fail(error: DataTransferError.noResponse)    // TODO, another error type
        .eraseToAnyPublisher()
    }

    return accountShowsRepository.fetchWatchListShows(page: requestValue.page,
                                                      userId: userLogged.id,
                                                      sessionId: userLogged.sessionId)
  }
}
