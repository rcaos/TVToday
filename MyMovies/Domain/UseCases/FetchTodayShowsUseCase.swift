//
//  FetchTodayMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

// MARK: - TODO, tendría que tener una abstraccion para
//  Today, Popular, lo que cambia es la URL,

protocol FetchTodayShowsUseCase {
    func execute(requestValue: FetchTodayUseCaseRequestValue,
                 completion: @escaping(Result<TVShowResult, Error>) -> Void) -> Cancellable?
}

struct FetchTodayUseCaseRequestValue {
    let page: Int
}

// MARK: - DefaultFetchTodayShowsUseCase

final class DefaultFetchTodayShowsUseCase: FetchTodayShowsUseCase {
    
    private let tvShowsRepository: TVShowsRepository
    
    init(tvShowsRepository: TVShowsRepository) {
        self.tvShowsRepository = tvShowsRepository
    }
    
    func execute(requestValue: FetchTodayUseCaseRequestValue,
                 completion: @escaping (Result<TVShowResult, Error>) -> Void) -> Cancellable? {
        
        return tvShowsRepository.tvShowsList(page: requestValue.page) { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
    
}
