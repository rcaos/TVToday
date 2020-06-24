//
//  MarkAsFavoriteUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol MarkAsFavoriteUseCase {
  func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> Observable<Result<Bool, Error>>
}

struct MarkAsFavoriteUseCaseRequestValue {
  let showId: Int
  let favorite: Bool
}

final class DefaultMarkAsFavoriteUseCase: MarkAsFavoriteUseCase {
  
  private let accountRepository: AccountRepository
  
  private let keychainRepository: KeychainRepository
  
  init(accountRepository: AccountRepository,
       keychainRepository: KeychainRepository) {
    self.accountRepository = accountRepository
    self.keychainRepository = keychainRepository
  }
  
  func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> Observable<Result<Bool, Error>> {
    
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Observable.just(Result.failure(CustomError.genericError))
    }
    
    return accountRepository.markAsFavorite(
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
