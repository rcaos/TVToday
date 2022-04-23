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
  private let dataTransferService: DataTransferService

  private let basePath: String?

  public init(dataTransferService: DataTransferService,
              basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - TVEpisodesRepository
extension DefaultTVEpisodesRepository: TVEpisodesRepository {

  func fetchEpisodesList(for show: Int, season: Int) -> AnyPublisher<SeasonResult, DataTransferError> {
    let endpoint = Endpoint<SeasonResult>(
      path: "3/tv/\(show)/season/\(season)",
      method: .get
    )

    return dataTransferService.request(with: endpoint)
      .map { self.mapEpisodesWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  private func mapEpisodesWithBasePath(response: SeasonResult) -> SeasonResult {
    guard let basePath = basePath else {
      return response
    }

    var newResponse = response

    newResponse.episodes  = response.episodes?.map { (episode: Episode) -> Episode in
      var mutableEpisode = episode
      mutableEpisode.posterPath = basePath + "/t/p/w342" + ( episode.posterPath ?? "" )
      return mutableEpisode
    }

    return newResponse
  }
}
