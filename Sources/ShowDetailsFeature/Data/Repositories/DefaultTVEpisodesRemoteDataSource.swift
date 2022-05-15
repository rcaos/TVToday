//
//  DefaultTVEpisodesRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Combine
import Networking
import NetworkingInterface

public final class DefaultTVEpisodesRemoteDataSource {
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

extension DefaultTVEpisodesRemoteDataSource: TVEpisodesRemoteDataSource {
  public func fetchEpisodes(for showId: Int, season: Int) -> AnyPublisher<TVShowSeasonDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowSeasonDTO>(
      path: "3/tv/\(showId)/season/\(season)",
      method: .get
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }
}
