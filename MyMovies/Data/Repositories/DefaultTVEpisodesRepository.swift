//
//  DefaultTVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultTVEpisodesRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - TVEpisodesRepository

extension DefaultTVEpisodesRepository: TVEpisodesRepository {
    
    func tvEpisodesList(for show: Int, season: Int, completion: @escaping (Result<SeasonResult, Error>) -> Void) -> Cancellable? {
        let endPoint = TVShowsProvider.getEpisodesFor(show, season)
        
        let networkTask = dataTransferService.request(service: endPoint, decodeType: SeasonResult.self, completion: completion)
        
        return RepositoryTask(networkTask: networkTask)
    }
}
