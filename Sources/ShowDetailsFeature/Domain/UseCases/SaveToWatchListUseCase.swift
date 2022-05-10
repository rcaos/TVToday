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

  init(accountShowsRepository: AccountTVShowsDetailsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  public func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    return accountShowsRepository.saveToWatchList(
      tvShowId: requestValue.showId,
      watchedList: requestValue.watchList
    )
      .map { _ in requestValue.watchList }
      .eraseToAnyPublisher()
  }
}
