//
//  MarkAsFavoriteUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Shared

public protocol MarkAsFavoriteUseCase {
  func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> Observable<Result<Bool, Error>>
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
  
  public func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> Observable<Result<Bool, Error>> {
    
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Observable.just(Result.failure(CustomError.genericError))
    }
    
    return accountShowsRepository.markAsFavorite(
      session: account.sessionId,
      userId: String(account.id),
      tvShowId: requestValue.showId,
      favorite: requestValue.favorite)
      .flatMap { _ -> Observable<Result<Bool, Error>> in
        return Observable.just( Result.success(requestValue.favorite) )
    }
    .catchErrorJustReturn( Result.failure(CustomError.genericError) )
  }
}
