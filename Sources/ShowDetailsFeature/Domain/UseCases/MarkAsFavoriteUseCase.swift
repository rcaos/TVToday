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
  private let keychainRepository: KeychainRepository

  public init(accountShowsRepository: AccountTVShowsDetailsRepository,
              keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }

  public func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() // TODO, use other error
    }

    return accountShowsRepository.markAsFavorite(
      tvShowId: requestValue.showId,
      userId: String(account.id),
      session: account.sessionId,
      favorite: requestValue.favorite
    )
      .map { _ in requestValue.favorite }
      .eraseToAnyPublisher()
  }
}
