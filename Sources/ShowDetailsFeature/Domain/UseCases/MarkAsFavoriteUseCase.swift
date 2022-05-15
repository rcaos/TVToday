//
//  MarkAsFavoriteUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared
import NetworkingInterface

public protocol MarkAsFavoriteUseCase {
  func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError>
}

public struct MarkAsFavoriteUseCaseRequestValue {
  let showId: Int
  let favorite: Bool
}

public final class DefaultMarkAsFavoriteUseCase: MarkAsFavoriteUseCase {
  private let accountShowsRepository: AccountTVShowsDetailsRepository

  public init(accountShowsRepository: AccountTVShowsDetailsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  public func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    return accountShowsRepository.markAsFavorite(
      tvShowId: requestValue.showId,
      favorite: requestValue.favorite
    )
      .map { _ in requestValue.favorite }
      .eraseToAnyPublisher()
  }
}
