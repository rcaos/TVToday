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
    
    func tvShowsList(with filter: TVShowsListFilter,
                     page: Int,
                     completion: @escaping (Result<TVShowResult, Error>) -> Void) -> Cancellable? {
        
        let endPoint = getProvider(with: filter, page: page)
        
        let networkTask = dataTransferService.request(service: endPoint,
                         decodeType: TVShowResult.self,
                         completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
    
    private func getProvider(with filter: TVShowsListFilter, page: Int) -> TVShowsProvider {
        switch filter {
        case .today:
            return TVShowsProvider.getAiringTodayShows(page)
        case .popular:
            return TVShowsProvider.getPopularTVShows(page)
        case .byGenre(let genreId):
            return TVShowsProvider.listTVShowsBy(genreId, page)
        case .search(let query):
            return TVShowsProvider.searchTVShow(query, page)
        }
    }
}
