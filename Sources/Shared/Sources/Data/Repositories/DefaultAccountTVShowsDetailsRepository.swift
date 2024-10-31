//
//  Created by Jeans Ruiz on 5/05/22.
//

import NetworkingInterface

public final class DefaultAccountTVShowsDetailsRepository {
  private let showsRemoteDataSource: AccountTVShowsDetailsRemoteDataSourceProtocol
  private let mapper: AccountTVShowsDetailsMapperProtocol
  private let loggedUserRepository: LoggedUserRepositoryProtocol
  
  public init(
    showsRemoteDataSource: AccountTVShowsDetailsRemoteDataSourceProtocol,
    mapper: AccountTVShowsDetailsMapperProtocol,
    loggedUserRepository: LoggedUserRepositoryProtocol
  ) {
    self.showsRemoteDataSource = showsRemoteDataSource
    self.mapper = mapper
    self.loggedUserRepository = loggedUserRepository
  }
}

extension DefaultAccountTVShowsDetailsRepository: AccountTVShowsDetailsRepository {
  
  // MARK: - TODO, handle nil cases, consider change the LoggedUserRepository signature instead
  public func markAsFavorite(tvShowId: Int, favorite: Bool) async throws -> TVShowActionStatus {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0
    
    let markResult = try await showsRemoteDataSource.markAsFavorite(
      tvShowId: tvShowId, userId: String(userId),
      session: loggedUser?.sessionId ?? "",
      favorite: favorite
    )
    return mapper.mapActionResult(result: markResult)
  }
  
  public func saveToWatchList(tvShowId: Int, watchedList: Bool) async throws -> TVShowActionStatus {
    let loggedUser = loggedUserRepository.getUser()
    let userId = loggedUser?.id ?? 0
    
    let saveResult = try await showsRemoteDataSource.saveToWatchList(tvShowId: tvShowId, userId: String(userId), session: loggedUser?.sessionId ?? "", watchedList: watchedList)
    return mapper.mapActionResult(result: saveResult)
  }
  
  public func fetchTVShowStatus(tvShowId: Int) async throws -> TVShowAccountStatus {
    let sessionId = loggedUserRepository.getUser()?.sessionId ?? ""
    let sessionResult = try await showsRemoteDataSource.fetchTVShowStatus(tvShowId: tvShowId, sessionId: sessionId)
    return mapper.mapTVShowStatusResult(result: sessionResult)
  }
}
