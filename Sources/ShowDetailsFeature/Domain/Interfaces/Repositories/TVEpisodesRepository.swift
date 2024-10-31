//
//  Created by Jeans Ruiz on 1/20/20.
//

import Foundation
import NetworkingInterface
import Shared

protocol TVEpisodesRepository {
  func fetchEpisodesList(for show: Int, season: Int) async throws -> TVShowSeason // MARK: - TODO, Change Name
}

public protocol TVEpisodesRemoteDataSource {
  func fetchEpisodes(for showId: Int, season: Int) async throws -> TVShowSeasonDTO
}

public protocol TVEpisodesMapperProtocol {
  func mapSeasonDTO(_ season: TVShowSeasonDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowSeason
}
