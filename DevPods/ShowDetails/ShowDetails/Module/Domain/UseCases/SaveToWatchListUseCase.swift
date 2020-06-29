//
//  SaveToWatchList.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Shared

public protocol SaveToWatchListUseCase {
  func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> Observable<Result<Bool, Error>>
}

public struct SaveToWatchListUseCaseRequestValue {
  let showId: Int
  let watchList: Bool
}

final class DefaultSaveToWatchListUseCase: SaveToWatchListUseCase {
  
  private let accountShowsRepository: AccountTVShowsRepository
  
  private let keychainRepository: KeychainRepository
  
  init(accountShowsRepository: AccountTVShowsRepository,
       keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }
  
  public func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> Observable<Result<Bool, Error>> {
    
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Observable.just(Result.failure(CustomError.genericError))
    }
    
    return accountShowsRepository.saveToWatchList(
      session: account.sessionId,
      userId: String(account.id),
      tvShowId: requestValue.showId,
      watchedList: requestValue.watchList)
      .flatMap { _ -> Observable<Result<Bool, Error>> in
        return Observable.just(Result.success(requestValue.watchList))
    }
    .catchErrorJustReturn( Result.failure(CustomError.genericError) )
  }
}
