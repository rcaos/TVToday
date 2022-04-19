//
//  TVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

protocol TVEpisodesRepository {
  func fetchEpisodesList(for show: Int, season: Int) -> AnyPublisher<SeasonResult, DataTransferError>
}
