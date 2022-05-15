//
//  DefaultTVEpisodesRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Networking
import Shared

public final class DefaultTVEpisodesRepository {
  private let remoteDataSource: TVEpisodesRemoteDataSource
  private let mapper: TVEpisodesMapperProtocol
  private let imageBasePath: String

  public init(remoteDataSource: TVEpisodesRemoteDataSource, mapper: TVEpisodesMapperProtocol, imageBasePath: String) {
    self.remoteDataSource = remoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
  }
}

extension DefaultTVEpisodesRepository: TVEpisodesRepository {

  func fetchEpisodesList(for show: Int, season: Int) -> AnyPublisher<TVShowSeason, DataTransferError> {
    return remoteDataSource.fetchEpisodes(for: show, season: season)
      .map { self.mapper.mapSeasonDTO($0, imageBasePath: self.imageBasePath, imageSize: .small) }
      .eraseToAnyPublisher()
  }
}
