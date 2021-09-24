//
//  SearchTVShowsUseCase.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import RxSwift
import Shared
import Persistence

public protocol SearchTVShowsUseCase {
  
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> Observable<TVShowResult>
}

public struct SearchTVShowsUseCaseRequestValue {
  public let query: String
  public let page: Int
}

// MARK: - SearchTVShowsUseCase

final class DefaultSearchTVShowsUseCase: SearchTVShowsUseCase {
  
  private let tvShowsRepository: TVShowsRepository
  private let searchsLocalRepository: SearchLocalRepository
  private let keychainRepository: KeychainRepository
  
  public init(tvShowsRepository: TVShowsRepository,
              keychainRepository: KeychainRepository,
              searchsLocalRepository: SearchLocalRepository) {
    self.tvShowsRepository = tvShowsRepository
    self.keychainRepository = keychainRepository
    self.searchsLocalRepository = searchsLocalRepository
  }
  
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    
    var idLogged = 0
    if let userLogged = keychainRepository.fetchLoguedUser() {
      idLogged = userLogged.id
    }
    
    return tvShowsRepository.searchShowsFor(query: requestValue.query,
                                            page: requestValue.page)
      .flatMap { resultSearch -> Observable<TVShowResult> in
        
        if requestValue.page == 1 {
          return self.searchsLocalRepository.saveSearch(query: requestValue.query, userId: idLogged)
            .flatMap { _ -> Observable<TVShowResult> in
              return Observable.just(resultSearch)
          }
        } else {
          return Observable.just(resultSearch)
        }
    }
  }
  
}
