//
//  FetchTVAccountStates.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared
import NetworkingInterface

protocol FetchTVAccountStates {
  func execute(requestValue: FetchTVAccountStatesRequestValue) -> AnyPublisher<TVShowAccountStatus, DataTransferError>
}

struct FetchTVAccountStatesRequestValue {
  let showId: Int
}

final class DefaultFetchTVAccountStates: FetchTVAccountStates {
  private let accountShowsRepository: AccountTVShowsDetailsRepository
  private let keychainRepository: KeychainRepository

  init(accountShowsRepository: AccountTVShowsDetailsRepository,
       keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }

  func execute(requestValue: FetchTVAccountStatesRequestValue) -> AnyPublisher<TVShowAccountStatus, DataTransferError> {
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Fail(error: .noResponse).eraseToAnyPublisher()
    }

    return accountShowsRepository.fetchTVShowStatus(tvShowId: requestValue.showId, sessionId: account.sessionId)
      .eraseToAnyPublisher()
  }
}
