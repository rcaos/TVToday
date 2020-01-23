//
//  FetchTodayMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchTVShowsUseCase {
    func execute(requestValue: FetchTVShowsUseCaseRequestValue,
                 completion: @escaping(Result<TVShowResult, Error>) -> Void) -> Cancellable?
}

struct FetchTVShowsUseCaseRequestValue {
    let filter: TVShowsListFilter
    let page: Int
}

// MARK: - DefaultFetchTodayShowsUseCase

final class DefaultFetchTVShowsUseCase: FetchTVShowsUseCase {
    
    private let tvShowsRepository: TVShowsRepository
    
    init(tvShowsRepository: TVShowsRepository) {
        self.tvShowsRepository = tvShowsRepository
    }
    
    func execute(requestValue: FetchTVShowsUseCaseRequestValue,
                 completion: @escaping (Result<TVShowResult, Error>) -> Void) -> Cancellable? {
        
        return tvShowsRepository.tvShowsList(with: requestValue.filter,
                                             page: requestValue.page,
                                             completion: completion)
    }
}
