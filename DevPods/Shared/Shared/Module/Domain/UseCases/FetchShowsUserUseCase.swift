//
//  FetchShowsUserUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

// MARK: - DefaultFetchTodayShowsUseCase
//
//public final class DefaultUserFetchShowsUserUseCase: FetchTVShowsUseCase {
//  
//  private let tvShowsRepository: TVShowsRepository
//  
//  private let keychainRepository: KeychainRepository
//  
//  public init(tvShowsRepository: TVShowsRepository, keychainRepository: KeychainRepository) {
//    self.tvShowsRepository = tvShowsRepository
//    self.keychainRepository = keychainRepository
//  }
//  
//  public func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
//    guard let userLogued = keychainRepository.fetchLoguedUser(),
//      let repositorieFilter = mapRepositorieFilter(requestValue: requestValue, userLogued) else {
//        return Observable.error(CustomError.genericError)
//    }
//    
//    return tvShowsRepository.fetchAiringTodayShows(page: 3)
////    return tvShowsRepository.fetchTVShowsList(with: repositorieFilter, page: requestValue.page)
//  }
//  
//  fileprivate func mapRepositorieFilter(requestValue: FetchTVShowsUseCaseRequestValue,
//                                        _ userLogued: Account) -> TVShowsListFilter? {
//    return nil
//    
//    // MARK: - Refactor this,
////    var repositorieFilter: TVShowsListFilter?
//    
////    switch requestValue.filter {
////    case .favorites:
////      repositorieFilter = TVShowsListFilter.favorites(userId: userLogued.id, sessionId: userLogued.sessionId)
////    case .watchList:
////      repositorieFilter = TVShowsListFilter.watchList(userId: userLogued.id, sessionId: userLogued.sessionId)
////    default:
////      repositorieFilter = nil
////    }
//    
////    return repositorieFilter
//  }
//}
