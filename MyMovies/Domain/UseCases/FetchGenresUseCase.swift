//
//  SearchMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchGenresUseCase {
    
    func execute(requestValue: FetchGenresUseCaseRequestValue,
                 completion: @escaping (Result<GenreListResult, Error>) -> Void ) -> Cancellable?
}

struct FetchGenresUseCaseRequestValue {
    
}

final class DefaultFetchGenresUseCase: FetchGenresUseCase {
    
    private let genresRepository: GenresRepository
    
    init(genresRepository: GenresRepository) {
        self.genresRepository = genresRepository
    }
    
    func execute(requestValue: FetchGenresUseCaseRequestValue,
                 completion: @escaping (Result<GenreListResult, Error>) -> Void) -> Cancellable? {
        return genresRepository.genresList() { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}
