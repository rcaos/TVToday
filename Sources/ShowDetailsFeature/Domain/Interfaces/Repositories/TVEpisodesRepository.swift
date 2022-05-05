//
//  TVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Foundation
import NetworkingInterface
import Shared

protocol TVEpisodesRepository {
  func fetchEpisodesList(for show: Int, season: Int) -> AnyPublisher<TVShowSeason, DataTransferError> // MARK: - TODO, Change Name
}

public protocol TVEpisodesRemoteDataSource {
  func fetchEpisodes(for showId: Int, season: Int) -> AnyPublisher<TVShowSeasonDTO, DataTransferError>
}

public protocol TVEpisodesMapperProtocol {
  func mapSeasonDTO(_ season: TVShowSeasonDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowSeason
}
