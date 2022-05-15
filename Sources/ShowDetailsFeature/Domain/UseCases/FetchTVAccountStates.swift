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

  init(accountShowsRepository: AccountTVShowsDetailsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  func execute(requestValue: FetchTVAccountStatesRequestValue) -> AnyPublisher<TVShowAccountStatus, DataTransferError> {
    return accountShowsRepository.fetchTVShowStatus(tvShowId: requestValue.showId)
  }
}
