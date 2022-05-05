//
//  SaveToWatchList.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared
import NetworkingInterface

public protocol SaveToWatchListUseCase {
  func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError>
}

public struct SaveToWatchListUseCaseRequestValue {
  let showId: Int
  let watchList: Bool
}

final class DefaultSaveToWatchListUseCase: SaveToWatchListUseCase {
  private let accountShowsRepository: AccountTVShowsDetailsRepository
  private let keychainRepository: KeychainRepository

  init(accountShowsRepository: AccountTVShowsDetailsRepository,
       keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }

  public func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() // TODO, use other error
    }

    return accountShowsRepository.saveToWatchList(
      tvShowId: requestValue.showId,
      userId: String(account.id),
      session: account.sessionId,
      watchedList: requestValue.watchList
    )
      .map { _ in requestValue.watchList }
      .eraseToAnyPublisher()
  }
}
