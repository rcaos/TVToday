//
//  Created by Jeans Ruiz on 1/20/20.
//

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
  func fetchEpisodesList(for show: Int, season: Int) async throws -> TVShowSeason {
    let dto = try await remoteDataSource.fetchEpisodes(for: show, season: season)
    return mapper.mapSeasonDTO(dto, imageBasePath: imageBasePath, imageSize: .small)
  }
}
