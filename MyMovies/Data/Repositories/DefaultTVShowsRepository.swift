//
//  DefaultTVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultTVShowsRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - TVShowsRepository

extension DefaultTVShowsRepository: TVShowsRepository {
    
    func tvShowsList(page: Int,
                     completion: @escaping (Result<TVShowResult, Error>) -> Void) -> Cancellable? {
        
        let endPoint = APIEndpoints.todayTVShows(page: page)
        print("endPoint: [\(endPoint)]")
        let networkTask = self.dataTransferService.request(with: endPoint,
                                                           completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
}
