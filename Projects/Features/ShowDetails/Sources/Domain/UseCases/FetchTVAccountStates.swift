//
//  FetchTVAccountStates.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Shared

protocol FetchTVAccountStates {
  
  typealias Response = Result<TVShowAccountStateResult, Error>
  
  func execute(requestValue: FetchTVAccountStatesRequestValue) -> Observable<Response>
}

struct FetchTVAccountStatesRequestValue {
  let showId: Int
}

final class DefaultFetchTVAccountStates: FetchTVAccountStates {
  
  private let accountShowsRepository: AccountTVShowsRepository
  
  private let keychainRepository: KeychainRepository
  
  init(accountShowsRepository: AccountTVShowsRepository,
       keychainRepository: KeychainRepository) {
    self.accountShowsRepository = accountShowsRepository
    self.keychainRepository = keychainRepository
  }
  
  func execute(requestValue: FetchTVAccountStatesRequestValue) -> Observable<Response> {
    
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Observable.just( .failure(CustomError.genericError) )
    }
    
    return accountShowsRepository.fetchTVAccountStates(
      tvShowId: requestValue.showId,
      sessionId: account.sessionId)
      .flatMap { detailState -> Observable<Result<TVShowAccountStateResult, Error>> in
        return Observable.just(.success(detailState))
    }
    .catchErrorJustReturn(.failure(CustomError.genericError))
  }
}
