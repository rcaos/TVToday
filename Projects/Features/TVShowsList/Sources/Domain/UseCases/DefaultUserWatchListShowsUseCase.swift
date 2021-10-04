//
//  DefaultUserWatchListShowsUseCase.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import RxSwift
import Shared

public final class DefaultUserWatchListShowsUseCase: FetchTVShowsUseCase {
  private let accountShowsRepository: AccountTVShowsRepository

  private let keychainRepository: KeychainRepository

  public init(accountShowsRepository: AccountTVShowsRepository, keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }

  public func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    guard let userLogged = keychainRepository.fetchLoguedUser() else {
      return Observable.error(CustomError.genericError)
    }

    return accountShowsRepository.fetchWatchListShows(page: requestValue.page,
                                                      userId: userLogged.id,
                                                      sessionId: userLogged.sessionId)
  }
}
