//
//  Created by Jeans Ruiz on 6/27/20.
//

import NetworkingInterface
import Networking

public final class DefaultAccountTVShowsRepository {
  private let showsPageRemoteDataSource: AccountTVShowsRemoteDataSourceProtocol
  private let mapper: TVShowPageMapperProtocol
  private let imageBasePath: String
  private let loggedUserRepository: LoggedUserRepositoryProtocol

  public init(showsPageRemoteDataSource: AccountTVShowsRemoteDataSourceProtocol,
              mapper: TVShowPageMapperProtocol, imageBasePath: String,
              loggedUserRepository: LoggedUserRepositoryProtocol) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
    self.loggedUserRepository = loggedUserRepository
  }
}

extension DefaultAccountTVShowsRepository: AccountTVShowsRepository {

  public func fetchFavoritesShows(page: Int) async throws -> TVShowPage {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0

    let dto = try await showsPageRemoteDataSource.fetchFavoritesShows(page: page, userId: userId, sessionId: loggedUser?.sessionId ?? "")
    return mapper.mapTVShowPage(dto, imageBasePath: imageBasePath, imageSize: .medium)
  }

  public func fetchWatchListShows(page: Int) async throws -> TVShowPage {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0

    let dto = try await showsPageRemoteDataSource.fetchWatchListShows(page: page, userId: userId, sessionId: loggedUser?.sessionId ?? "")
    return mapper.mapTVShowPage(dto, imageBasePath: self.imageBasePath, imageSize: .medium)
  }
}
