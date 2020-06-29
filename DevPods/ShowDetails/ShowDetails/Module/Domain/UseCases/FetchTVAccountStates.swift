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
  func execute(requestValue: FetchTVAccountStatesRequestValue) -> Observable<TVShowAccountStateResult>
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
  
  func execute(requestValue: FetchTVAccountStatesRequestValue) -> Observable<TVShowAccountStateResult> {
    
    guard let account = keychainRepository.fetchLoguedUser() else {
      return Observable.error(CustomError.genericError)
    }
    
    return accountShowsRepository.fetchTVAccountStates(
      tvShowId: requestValue.showId,
      sessionId: account.sessionId)
  }
}
