//
//  DefaultUserFavoritesShowsUseCase.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import Shared
import NetworkingInterface

public final class DefaultUserFavoritesShowsUseCase: FetchTVShowsUseCase {
  private let accountShowsRepository: AccountTVShowsRepository

  public init(accountShowsRepository: AccountTVShowsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  public func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError> {
    return accountShowsRepository.fetchFavoritesShows(page: requestValue.page)
  }
}
