//
//  SaveToWatchList.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol SaveToWatchListUseCase {
  func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> Observable<Result<Bool, Error>>
}

struct SaveToWatchListUseCaseRequestValue {
  let showId: Int
  let watchList: Bool
}

final class DefaultSaveToWatchListUseCase: SaveToWatchListUseCase {
  
  private let accountRepository: AccountRepository
  
  private let keychainRepository: KeychainRepository
  
  init(accountRepository: AccountRepository,
       keychainRepository: KeychainRepository) {
    self.accountRepository = accountRepository
    self.keychainRepository = keychainRepository
  }
  
  func execute(requestValue: SaveToWatchListUseCaseRequestValue) -> Observable<Result<Bool, Error>> {
    
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Observable.just(Result.failure(CustomError.genericError))
    }
    
    return accountRepository.saveToWatchList(
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
