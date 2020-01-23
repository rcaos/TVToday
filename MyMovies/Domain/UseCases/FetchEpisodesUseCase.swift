//
//  FetchEpisodesUseCase.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchEpisodesUseCase {
    func execute(requestValue: FetchEpisodesUseCaseRequestValue, completion: @escaping (Result<SeasonResult, Error>) -> Void) -> Cancellable?
}

struct FetchEpisodesUseCaseRequestValue {
    let showIdentifier: Int
    let seasonNumber: Int
}

// MARK: - DefaultFetchEpisodesUseCase

final class DefaultFetchEpisodesUseCase: FetchEpisodesUseCase {
    
    private let episodesRepository: TVEpisodesRepository
    
    init(episodesRepository: TVEpisodesRepository) {
        self.episodesRepository = episodesRepository
    }
    
    func execute(requestValue: FetchEpisodesUseCaseRequestValue, completion: @escaping (Result<SeasonResult, Error>) -> Void) -> Cancellable? {
        
        return episodesRepository.tvEpisodesList(
            for: requestValue.showIdentifier,
            season: requestValue.seasonNumber,
            completion: completion)
    }
}
