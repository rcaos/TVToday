//
//  DefaultGenresRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultGenreRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - GenresRepository

extension DefaultGenreRepository: GenresRepository {
    
    func genresList(completion: @escaping (Result<GenreListResult, Error>) -> Void) -> Cancellable? {
        
        let endPoint = GenreProvider.getAll
        
        let networkTask = dataTransferService.request(service: endPoint,
                                                      decodeType: GenreListResult.self,
                                                      completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
    
    
    
}
