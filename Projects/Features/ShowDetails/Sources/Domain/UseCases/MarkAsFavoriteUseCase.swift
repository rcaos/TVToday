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
  private let accountShowsRepository: AccountTVShowsRepository
  private let keychainRepository: KeychainRepository

  public init(accountShowsRepository: AccountTVShowsRepository,
              keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }

  public func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() // TODO, use other error
    }

    return accountShowsRepository.markAsFavorite(
      session: account.sessionId,
      userId: String(account.id),
      tvShowId: requestValue.showId,
      favorite: requestValue.favorite)
      .map { _ in requestValue.favorite }
      .eraseToAnyPublisher()
  }
}
