//
//  Created by Jeans Ruiz on 4/05/22.
//

import Networking
import NetworkingInterface

public final class DefaultTVShowsDetailRepository {
  private let showsPageRemoteDataSource: TVShowsDetailsRemoteDataSourceProtocol
  private let mapper: TVShowDetailsMapperProtocol
  private let imageBasePath: String

  public init(
    showsPageRemoteDataSource: TVShowsDetailsRemoteDataSourceProtocol,
    mapper: TVShowDetailsMapperProtocol,
    imageBasePath: String
  ) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
  }
}

extension DefaultTVShowsDetailRepository: TVShowsDetailsRepository {
  public func fetchTVShowDetails(with showId: Int) async throws -> TVShowDetail {
    let dto = try await showsPageRemoteDataSource.fetchTVShowDetails(with: showId)
    return mapper.mapTVShow(dto, imageBasePath: imageBasePath, imageSize: .medium)
  }
}
