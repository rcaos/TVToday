//
//  TVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol TVEpisodesRepository {
    
    func tvEpisodesList(for show: Int, season: Int, completion: @escaping (Result<SeasonResult, Error>) -> Void) -> Cancellable?
}
